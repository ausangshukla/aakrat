class User < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  rolify
  accepts_nested_attributes_for :roles, allow_destroy: true, reject_if: :all_blank

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :trackable,
         :recoverable, :rememberable, :validatable, :confirmable

  # Only if this user is an employee of the company
  belongs_to :company, optional: true
  has_many :project_accesses, dependent: :destroy

  validates :first_name, :last_name, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }, presence: true

  # "CxO", "Founder", "Angel", "VC", "Admin",
  ROLES = %i[client team_lead team_member contractor accountant company_admin].freeze

  scope :admins, -> { where('roles.name': :company_admin).joins(:roles) }
  scope :accountants, -> { where('roles.name': :accountant).joins(:roles) }
  scope :clients, -> { where('roles.name': :client).joins(:roles) }
  scope :contractors, -> { where('roles.name': :contractor).joins(:roles) }
  scope :team_leads, -> { where('roles.name': :team_lead).joins(:roles) }
  scope :team_members, -> { where('roles.name': :team_member).joins(:roles) }

  before_create :setup_defaults

  def to_s
    full_name
  end

  def name
    full_name
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def setup_defaults
    add_role :team_member if company
    # add_role :investor if (company && company.company_type == "VC") || InvestorAccess.where(user_id: id).first.present?
    # add_role :secondary_buyer if company && ["Advisor", "Family Office", "VC"].include?(company.company_type)
    # add_role :startup if company && (company.company_type == "Startup")
    self.active = true
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  def active_for_authentication?
    active && !confirmed_at.nil?
  end

  def reset_password?
    sign_in_count == 1 && system_created
  end
end

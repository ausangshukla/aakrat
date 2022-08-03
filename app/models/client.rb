class Client < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  TYPES = %w[Client Accountant Contractor].freeze

  belongs_to :user
  belongs_to :company
  has_many :notes, as: :owner, dependent: :destroy
  has_rich_text :details

  validates :first_name, :last_name, :email, :phone, :user_type, presence: true

  scope :contractors, -> { where(user_type: "Contractor") }
  scope :clients, -> { where(user_type: "Client") }

  before_validation :set_user
  def set_user
    self.user = User.where(email:).first

    unless user
      password = (0...8).map { rand(65..90).chr }.join
      self.user = User.create(first_name:, last_name:,
                              email:, phone:, system_created: true,
                              active: true, password:)

    end

    # Add the right role
    case user_type
    when "Client"
      user.add_role(:client)
    when "Contractor"
      user.add_role(:contractor)
    when "Accountant"
      user.add_role(:accountant)
    end

    self.phone = user.phone
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

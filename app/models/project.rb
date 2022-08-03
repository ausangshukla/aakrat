class Project < ApplicationRecord
  resourcify
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :company
  belongs_to :client, class_name: "User"
  belongs_to :team_lead, class_name: "User"

  has_many :site_visits, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :payments, dependent: :destroy
  has_many :project_accesses, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :materials, dependent: :destroy

  has_many :notes, as: :owner, dependent: :destroy
  has_rich_text :details
  has_many_attached :profile_pics, service: :amazon, dependent: :destroy

  validates :name, :start_date, :end_date, :client_estimated_budget,
            :estimated_builtup_area, presence: true

  serialize :services

  FEE_TYPE = ["% of Budget", "Rate / SqFt"].freeze
  STATUS = ["Not Started", "In Progress", "Completed", "Halted", "Abandoned"].freeze
  PAYMENT_STATUS = ["Not Paid", "Partial Payment", "Paid", "N/A"].freeze

  monetize :payment_amount_cents, :client_estimated_budget_cents,
           :actual_cost_cents, :fees_cents, :per_sq_ft_rate_cents, with_model_currency: :currency

  def percentage_completed_days
    total_days.positive? ? completed_days * 100.0 / total_days : 0
  end

  before_save :set_fees
  def set_fees
    if per_sq_ft_rate.positive?
      self.fees = per_sq_ft_rate * estimated_builtup_area * (1 - (discount / 100.0))
    elsif percentage_of_estimated_budget.positive?
      self.fees = percentage_of_estimated_budget * client_estimated_budget * (1 - (discount / 100.0)) / 100.0
    end
  end

  def gross_fees
    if per_sq_ft_rate.positive?
      per_sq_ft_rate * estimated_builtup_area
    elsif percentage_of_estimated_budget.positive?
      percentage_of_estimated_budget * client_estimated_budget / 100.0
    end
  end

  def client?(user)
    project_accesses.select { |pa| pa.user_id == user.id && pa.role_name == "Client" }.present?
  end
end

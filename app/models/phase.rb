class Phase < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :company
  belongs_to :project
  acts_as_list scope: :project

  belongs_to :assigned_to, class_name: "User"

  has_many :notes, as: :owner, dependent: :destroy

  has_many :site_visits, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :payments, dependent: :delete_all
  has_many :attachments, dependent: :destroy

  has_rich_text :details
  monetize :payment_amount_cents, with_currency: ->(i) { i.project.currency }
  monetize :payment_due_cents, with_currency: ->(i) { i.project.currency }

  validates :name, :start_date, :days, presence: true
  validates :days, numericality: { greater_than: 0 }

  scope :payment_required, -> { where(payment_required: true) }
  scope :visible_to_client, -> { where(visible_to_client: true) }

  before_save :set_end_date
  before_save :set_payment_status
  before_save :set_completed

  STATUS = ["Not Started", "In Progress", "Client Review", "Completed", "Halted"].freeze

  def set_end_date
    self.end_date = start_date + days.days
  end

  def set_completed
    self.completed = total_days.positive? && total_days == completed_days
    if completed
      self.status = "Completed"
    else
      self.status = "In Progress" unless ["Halted", "Client Review"].include?(status)
    end
  end

  def set_payment_status
    if payment_required
      self.payment_due_cents = payment_due_percentage * project.fees_cents / 100.0
      self.payment_status = if payment_amount_cents.zero?
                              completed ? "Pending" : "Not Paid"
                            else
                              due_amount.positive? ? "Partial" : "Paid"
                            end
    else
      self.payment_status = "N/A"
    end
  end

  after_update ->(_p) { PhaseMailer.with(phase_id: id).notify_update.deliver_later if project.status == "In Progress" }

  def delayed?
    Time.zone.today >= end_date && !completed
  end

  def on_time_status
    if completed
      "Complete"
    else
      Time.zone.today < end_date ? "On-Time" : "Delayed"
    end
  end

  def due_amount
    payment_due - payment_amount
  end

  def percentage_completed_days
    total_days.positive? ? completed_days * 100.0 / total_days : 0
  end

  def visible_status
    visible_to_client ? "Visible" : "Hidden"
  end
end

# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  company_id        :integer          not null
#  amount           :decimal(10, 2)   default("0.00"), not null
#  plan             :string(30)
#  discount         :decimal(10, 2)   default("0.00")
#  reference_number :string(255)
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#

class Payment < ApplicationRecord
  include Trackable
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  STATUS = %w[Pending Received Overdue Defaulted].freeze

  RECVD_STATUS = %w[Received Confirmed].freeze

  belongs_to :company
  belongs_to :user
  belongs_to :phase, optional: true

  belongs_to :project

  has_rich_text :details
  has_many_attached :attachments, service: :amazon, dependent: :destroy

  validates :amount, :due_date, presence: true
  validates :amount, numericality: { greater_than: 0 }

  monetize :amount_cents, with_currency: ->(i) { i.project.currency }

  counter_culture :phase,
                  column_name: proc { |p| p.status && RECVD_STATUS.include?(p.status) ? 'payment_amount_cents' : nil },
                  delta_column: 'amount_cents'

  counter_culture :project,
                  column_name: proc { |p| p.status && RECVD_STATUS.include?(p.status) ? 'payment_amount_cents' : nil },
                  delta_column: 'amount_cents'

  before_save :set_status
  after_save ->(p) { PaymentStatusJob.perform_later(p.id) }

  def set_status
    self.status = "Overdue" if Time.zone.today > due_date && status == "Pending"

    self.received_on ||= Time.zone.now if status_changed? && (status == "Received" || status == "Confirmed")
  end

  def overdue?
    due_date && Time.zone.today > due_date && status == "Pending"
  end
end

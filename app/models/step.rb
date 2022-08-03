class Step < ApplicationRecord
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  STATUS = ["Not Started", "In Progress", "Completed", "Halted"].freeze

  belongs_to :project
  belongs_to :company
  belongs_to :phase
  acts_as_list scope: :phase

  belongs_to :assigned_to, class_name: "User"

  has_many :client_attachments, class_name: "Attachment", dependent: :destroy
  has_many :notes, as: :owner, dependent: :destroy
  has_many :daily_activities, dependent: :destroy

  has_rich_text :details
  has_many_attached :attachments, service: :amazon, dependent: :destroy

  validates :name, :start_date, :days, presence: true
  validates :days, numericality: { greater_than: 0 }

  scope :visible_to_client, -> { where(visible_to_client: true) }

  monetize :cost_cents, with_currency: ->(i) { i.project.currency }

  before_save :set_end_date

  counter_culture :phase,
                  column_name: proc { |s| s.completed ? 'completed_days' : nil },
                  delta_column: 'days'

  counter_culture :phase,
                  column_name: 'total_days',
                  delta_column: 'days'

  counter_culture :project,
                  column_name: proc { |s| s.completed ? 'completed_days' : nil },
                  delta_column: 'days'

  counter_culture :project,
                  column_name: 'total_days',
                  delta_column: 'days'

  after_update ->(_s) { StepMailer.with(step_id: id).notify_update.deliver_later if project.status == "In Progress" }
  after_commit ->(s) { PhaseCompletedJob.perform_later(s.phase_id) }

  def set_end_date
    self.end_date = start_date + days.days
  end

  def delayed?
    Time.zone.today > end_date && !completed
  end

  def on_time_status
    if completed
      "Completed"
    else
      Time.zone.today <= end_date ? "On-Time" : "Delayed"
    end
  end

  def visible_status
    visible_to_client ? "Visible" : "Hidden"
  end
end

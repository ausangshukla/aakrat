class DailyActivity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :step
  belongs_to :company

  monetize :cost_cents, with_currency: ->(i) { i.project.currency }

  counter_culture :step,
                  column_name: proc { |a| a.status == "Completed" ? 'cost_cents' : nil },
                  delta_column: 'cost_cents'
end

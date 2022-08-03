class DailyActivity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :step
  belongs_to :company

  monetize :cost_cents, with_currency: ->(i) { i.project.currency }
end

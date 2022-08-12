class DailyActivity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :step
  belongs_to :company

  monetize :cost_cents, with_currency: ->(i) { i.project.currency }

  counter_culture :step,
                  column_name: proc { |a| a.status == "Completed" ? 'cost_cents' : nil },
                  delta_column: 'cost_cents'

  before_save :set_costs
  def set_costs
    self.cost_cents = quantity * step.unit_cost_cents if step.unit_cost_cents.positive?
  end
end

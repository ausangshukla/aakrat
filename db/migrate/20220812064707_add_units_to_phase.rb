class AddUnitsToPhase < ActiveRecord::Migration[7.0]
  def change
    add_column :steps, :quantity, :decimal, precision: 20, scale: 2, default: "0.0"
    add_column :daily_activities, :quantity, :decimal, precision: 20, scale: 2, default: "0.0"
    add_column :steps, :unit_cost_cents, :decimal, precision: 20, scale: 2, default: "0.0"
    add_column :steps, :estimated_cost_cents, :decimal, precision: 20, scale: 2, default: "0.0"
    add_column :steps, :units, :string, limit: 10
  end
end

class CreateDailyActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_activities do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :step, null: false, foreign_key: true
      t.text :details
      t.string :status, limit: 15
      t.decimal :cost_cents, precision: 20, scale: 2, default: "0.0"

      t.timestamps
    end
  end
end

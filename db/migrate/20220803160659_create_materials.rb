class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.references :company, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.references :owner, polymorphic: true, null: true
      t.string :category, limit: 40
      t.string :item, limit: 50
      t.string :material, limit: 50
      t.text :description
      t.integer :quantity, default: 0
      t.decimal :unit_cost_cents, precision: 20, scale: 2, default: "0.0"
      t.decimal :cost_cents, precision: 20, scale: 2, default: "0.0"
      t.date :required_by_date
      t.integer :reminder_days_before

      t.timestamps
    end
  end
end

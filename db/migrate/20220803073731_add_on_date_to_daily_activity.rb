class AddOnDateToDailyActivity < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_activities, :on_date, :date
    add_column :daily_activities, :title, :string
  end
end

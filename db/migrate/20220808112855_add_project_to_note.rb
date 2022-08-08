class AddProjectToNote < ActiveRecord::Migration[7.0]
  def change
    add_reference :notes, :project, null: false, foreign_key: true
  end
end

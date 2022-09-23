class AddIndexToHabitItems < ActiveRecord::Migration[7.0]
  def change
    add_index :habit_items, %i[habit_id date], unique: true
  end
end

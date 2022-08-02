class CreateHabitItems < ActiveRecord::Migration[7.0]
  def change
    create_table :habit_items do |t|
      t.references :habit, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :quantity, default: 0

      t.timestamps
    end
  end
end

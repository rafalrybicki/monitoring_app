class CreateDays < ActiveRecord::Migration[7.0]
  def change
    create_table :days do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :number_of_tasks, default: 0
      t.integer :number_of_completed_tasks, default: 0

      t.timestamps
    end
    add_index :days, :date
  end
end

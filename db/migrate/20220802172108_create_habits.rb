class CreateHabits < ActiveRecord::Migration[7.0]
  def change
    create_table :habits do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :daily_target, default: 0
      t.integer :weekly_target, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end

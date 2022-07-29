class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.integer :original_id, null: false
      t.references :user, null: false, foreign_key: true
      t.references :day, null: false, foreign_key: true
      t.string :content
      t.boolean :completed

      t.timestamps
    end
  end
end

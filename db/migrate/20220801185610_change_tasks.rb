class ChangeTasks < ActiveRecord::Migration[7.0]
  def change
    change_column :tasks, :content, :string, null: false
    change_column :tasks, :completed, :boolean, default: false
    add_column :tasks, :date, :date, null: false
    add_column :tasks, :cancelled, :boolean, default: false
    remove_column :tasks, :day_id
    remove_column :tasks, :original_id
  end
end

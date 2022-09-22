class AddOrderToHabits < ActiveRecord::Migration[7.0]
  def change
    add_column :habits, :order, :integer, default: 1
  end
end

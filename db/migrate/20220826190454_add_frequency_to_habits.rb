class AddFrequencyToHabits < ActiveRecord::Migration[7.0]
  def change
    add_column :habits, :frequency, :integer, array: true, default: []
  end
end

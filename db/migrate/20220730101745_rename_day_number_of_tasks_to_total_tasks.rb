class RenameDayNumberOfTasksToTotalTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :days, :number_of_tasks, :total_tasks
  end
end

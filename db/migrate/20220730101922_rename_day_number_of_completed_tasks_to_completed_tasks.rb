class RenameDayNumberOfCompletedTasksToCompletedTasks < ActiveRecord::Migration[7.0]
  def change
    rename_column :days, :number_of_completed_tasks, :completed_tasks
  end
end

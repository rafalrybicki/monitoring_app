class TasksController < ApplicationController
  before_action :set_day
  before_action :set_task, except: %i[new create]

  def new
    @task = Task.new
  end

  def create
    @task = @day.tasks.new(task_params)
    @task.user_id = current_user.id
    @task.save

    redirect_to @day
  end

  def edit; end

  def update
    @task.update(task_params)
    redirect_to @day
  end

  def delete; end

  private

  def set_day
    @day = current_user.days.find(params[:day_date])
  end

  def set_task
    @task = @day.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:content, :completed)
  end
end

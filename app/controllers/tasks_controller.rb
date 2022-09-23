class TasksController < ApplicationController
  before_action :set_day, except: %i[index cancel]
  before_action :set_task, only: %i[edit update destroy]

  def index
    @start_date = today
    @end_date = @start_date + 7.days

    tasks = current_user.tasks.order(:date).where('date >= ? AND date <= ?', @start_date, @end_date)

    @days = Hash.new { |h, k| h[k] = [] }
    tasks.each { |task| @days[task.date.to_fs] << task }
  end

  def new
    @task = Task.new
  end

  def create
    @task = @day.tasks.new(task_params)
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        @day.increment!(:total_tasks)
        session[:day_values]['total_tasks'] += 1

        format.turbo_stream
        format.html { redirect_to @day.date }
      else
        render :new, status: :unprocessable_entity, notice: 'Something went wrong'
      end
    end
  end

  def edit; end

  def update
    prev_completed = @task.completed

    respond_to do |format|
      if @task.update!(task_params)
        if !prev_completed && @task.completed
          @day.increment!(:completed_tasks)
          session[:day_values]['completed_tasks'] += 1
        elsif prev_completed && !@task.completed
          @day.decrement!(:completed_tasks)
          session[:day_values]['completed_tasks'] -= 1
        end

        format.turbo_stream
        format.html { redirect_to @day }
      else
        format.html { render @day, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy
    @day.decrement!(:total_tasks)
  end

  def cancel
    task = Task.find(params[:id])
    task.update!(cancelled: true)

    if params[:new_date]
      new_task = Task.create!(content: task.content, date: params[:new_date], user_id: current_user.id)
      new_task.day.increment!(:total_tasks)
      session[:day_values]['total_tasks'] += 1 if new_task.date == today
    end

    redirect_to today_path
  end

  private

  def task_params
    params.require(:task).permit(:content, :completed, :cancelled)
  end

  def set_day
    @day = current_user.days.friendly.find(params[:day_id])
  end

  def set_task
    @task = @day.tasks.find(params[:id])

    authorize_user(@task.user_id)
  end
end

class TasksController < ApplicationController
  before_action :set_day
  before_action :set_task, except: %i[new create]

  def new
    @task = Task.new
  end

  def create
    @task = @day.tasks.new(task_params)
    @task.user_id = current_user.id

    respond_to do |format|
      if @task.save
        @day.increment!(:total_tasks)
        notice = 'Task was successfully created.'
        session[:day_values]['total_tasks'] += 1

        format.turbo_stream { flash.now[:notice] = notice }
        format.html { redirect_to @day, notice: }
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
    @task.delete
    @day.decrement!(:total_tasks)
  end

  def reschedule
    @task.update!(cancelled: true)
    current_user.tasks.create!(content: @task.content, date: params[:new_date]) if params[:new_date]
    @day.increment!(:total_tasks)

    redirect_to @day
  end

  private

  def set_day
    @day = current_user.days.find(params[:day_date])
  end

  def set_task
    @task = @day.tasks.find(params[:id])

    authorize_user(@task.user_id)
  end

  def task_params
    params.require(:task).permit(:content, :completed, :cancelled)
  end
end

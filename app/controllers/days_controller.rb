class DaysController < ApplicationController
  before_action :set_day, except: %i[index]
  before_action :set_tasks, except: %i[index edit update]
  before_action :set_habits, except: %i[index edit update]
  before_action :set_day_values, except: %i[index edit update]

  def index
    @days = current_user.days
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @day.update!(params.require(:day).permit(:summary))

        format.turbo_stream
        format.html { redirect_to @day }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def today
    session[:day_values] = {
      'total_tasks' => @day.total_tasks,
      'completed_tasks' => @day.completed_tasks,
      'completed_habits' => @completed_habits,
      'total_habits' => @total_habits
    }

    @overdue_tasks = current_user.tasks.includes(:day).not_completed

    render :show
  end

  private

  def set_day
    @day = if params[:action] == 'show'
             current_user.days.preload(:tasks, :habits).find(params[:id])
           else
             current_user.days.preload(:tasks, :habits).find_by_date(Date.today)
           end
  end

  def set_tasks
    @tasks = @day.tasks
  end

  def set_habits
    day_habits = @day.habits.joins(:habit).select(:id, :habit_id, :date, :quantity, :name, :daily_target)
    @monitored = []
    @habits = []
    @total_habits = 0
    @completed_habits = 0

    day_habits.map do |habit|
      if habit.daily_target > 0
        @habits << habit
        @total_habits += habit.daily_target
        @completed_habits += habit.quantity <= habit.daily_target ? habit.quantity : habit.daily_target
      else
        @monitored << habit
      end
    end
  end

  def set_day_values
    if @day.date <= Date.today
      session[:day_values] = {
        'total_tasks' => @day.total_tasks,
        'completed_tasks' => @day.completed_tasks,
        'completed_habits' => @completed_habits,
        'total_habits' => @total_habits
      }
    end
  end
end

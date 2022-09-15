class DaysController < ApplicationController
  before_action :set_day, except: %i[index]
  before_action :set_tasks, except: %i[index edit update]
  before_action :set_habits, except: %i[index edit update]
  before_action :set_day_values, only: %i[show today]

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
    @overdue_tasks = current_user.tasks.includes(:day).not_completed

    render :show
  end

  private

  def set_day
    @day = if params[:action] == 'today'
             current_user.days.preload(:tasks, :habits).find_by_date(Date.today)
           else
             current_user.days.preload(:tasks, :habits).friendly.find(params[:id])
           end
  end

  def set_tasks
    @tasks = @day.tasks
  end

  def set_habits
    day_habits = Habit.find_by_sql(['
      SELECT
        id,
        item_id,
        name,
        date,
        quantity,
        daily_target
      FROM
        habits
      LEFT OUTER JOIN (
        SELECT
          date,
          quantity,
          id as item_id,
          habit_id
        FROM
          habit_items
        WHERE
          date = ?
      ) as habit_items ON
        habits.id = habit_items.habit_id
      WHERE ? = ANY(habits.frequency)
    ', @day.date, @day.date.wday])

    @monitored = []
    @habits = []
    @total_habits = 0
    @completed_habits = 0

    day_habits.map do |habit|
      habit.quantity = habit.quantity.to_i # 0 if habit_item doesn't exist
      habit.date = @day.date
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

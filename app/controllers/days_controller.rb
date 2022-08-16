class DaysController < ApplicationController
  before_action :set_day, except: :index
  before_action :set_tasks, except: :index
  before_action :set_habits, except: :index
  before_action :set_day_percentage, except: :index

  def index
    @days = current_user.days
  end

  def show; end

  def today
    @overdue_tasks = current_user.tasks.not_completed
    render :show
  end

  private

  def set_day
    date = param_date
    @day = current_user.days.preload(:tasks, :habits).find(date)
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

  def set_day_percentage
    @day_percentage = day_percentage(@day.total_tasks, @day.completed_tasks, @total_habits, @completed_habits)
  end
end

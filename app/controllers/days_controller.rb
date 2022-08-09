class DaysController < ApplicationController
  before_action :set_day, except: :index
  before_action :set_tasks, except: :index
  before_action :set_habits, except: :index

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
    date = params[:date] || Date.today
    @day = current_user.days.preload(:tasks, :habit_items).find(date)
  end

  def set_tasks
    @tasks = @day.tasks
  end

  def set_habits
    @habits = @day.habit_items.joins(:habit).select(:id, :date, :quantity, :name, :daily_target)
    @total_habits = 0
    @completed_habits = 0

    @habits.map do |habit|
      if habit.daily_target > 0
        @total_habits += habit.daily_target
        @completed_habits += habit.quantity <= habit.daily_target ? habit.quantity : habit.daily_target
      end
    end
  end
end

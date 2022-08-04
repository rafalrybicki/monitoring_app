class HabitsController < ApplicationController
  def index
    @today = Date.today
    start_date = @today.beginning_of_month
    end_date = @today.end_of_month
    @dates = start_date..end_date

    @habits = Habit.eager_load(:habit_items)
                   .order(:date)
                   .where('habit_items.date >= ? AND habit_items.date <= ?', start_date, end_date).all
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
    @habit.user_id = current_user.id
    @habit.save!

    redirect_to habits_path
  end

  def edit
    @habit = Habit.find(params[:id])
  end

  def update; end

  def destroy; end

  private

  def habit_params
    params.require(:habit).permit(:name, :daily_target, :weekly_target, :status)
  end
end

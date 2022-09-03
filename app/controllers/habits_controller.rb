class HabitsController < ApplicationController
  include HabitsHelper

  def index
    @start_date = params[:view] ? param_date.beginning_of_week : param_date.beginning_of_month
    @end_date = params[:view] ? @start_date.end_of_week : @start_date.end_of_month
    @end_date = today if @start_date == today.beginning_of_month
    @days_of_month = params[:view] ? @start_date..@end_date : @start_date..@start_date.end_of_month

    habits = current_user.habits.order(:created_at).all
    habits_with_items = current_user.habits
                                    .order(:created_at)
                                    .eager_load(:items)
                                    .where('date >= ? AND date <= ?', @start_date, @end_date)

    @habits = []
    @monitored = []

    habits.each do |habit|
      habit_with_items = habits_with_items.find { |h| h.id = habit.id }

      habit.items + habit_with_items.items if habit_with_items

      if habit.daily_target > 0
        @habits << habit
      else
        @monitored << habit
      end
    end

    @days = Day.find_by_sql(["
      SELECT
        days.date,
        days.total_tasks,
        days.completed_tasks,
        SUM(
          CASE WHEN habits.quantity > habits.daily_target THEN habits.daily_target ELSE habits.quantity END
        ) as completed_habits,
        SUM(habits.daily_target) as total_habits
      FROM
        days
        LEFT OUTER JOIN (
          SELECT
            date,
            quantity,
            daily_target
          FROM
            habit_items
            JOIN habits ON habit_items.habit_id = habits.id
          WHERE
            habits.daily_target > 0
        ) as habits ON days.date = habits.date
      WHERE
        days.date >= ?
        AND days.date <= ?
      GROUP BY
        days.date,
        days.total_tasks,
        days.completed_tasks
      ORDER BY
        days.date
    ", @start_date, @end_date])

    # @days = current_user.days.where('date >= ? AND date <= ?', @start_date, today)
    # @habits_dates = {}
    # @days.each do |day|
    #   date = {
    #     total: 0,
    #     completed: 0
    #   }

    #   @habits.map do |habit|
    #     next unless habit.daily_target > 0

    #     daily_target = habit.daily_target
    #     habit_item = habit.items.find { |item| item.date == day.date }

    #     if habit_item
    #       date[:total] += daily_target
    #       date[:completed] += habit_item.quantity <= daily_target ? habit_item.quantity : daily_target
    #     end
    #   end

    #   @habits_dates[day.date.to_s] = date
    # end
  end

  def show
    @habit = Habit.find(params[:id])
  end

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
    @habit.frequency = habit_frequency

    @habit.user_id = current_user.id

    respond_to do |format|
      if @habit.save
        format.turbo_stream
        format.html { redirect_to habits_path }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @habit = Habit.find(params[:id])

    authorize_user(@habit.user_id)
  end

  def update
    @habit = Habit.find(params[:id])
    @habit.frequency = habit_frequency

    respond_to do |format|
      if @habit.update!(habit_params)
        format.html { redirect_to habits_path }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @habit = Habit.find(params[:id])
    @habit.destroy

    redirect_to habits_path
  end

  private

  def habit_params
    params.require(:habit).permit(:name, :daily_target, :weekly_target, :status, :frequency)
  end
end

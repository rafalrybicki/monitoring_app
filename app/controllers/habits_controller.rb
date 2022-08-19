class HabitsController < ApplicationController
  def index
    @start_date = today.beginning_of_month
    @end_date = today # @start_date.end_of_month
    @days_of_month = 1..@start_date.end_of_month.day

    all_habits = Habit.eager_load(:items)
                      .order(:date)
                      .where('habit_items.date >= ? AND habit_items.date <= ?', @start_date, @end_date)

    @habits = all_habits.select { |habit| habit.daily_target > 0 }
    @monitored = all_habits.select { |habit| habit.daily_target == 0 }

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
        days.date
      ORDER BY
        days.date
    ", Date.today.beginning_of_month, today])

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

  def new
    @habit = Habit.new
  end

  def create
    @habit = Habit.new(habit_params)
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

  def update; end

  def destroy; end

  private

  def habit_params
    params.require(:habit).permit(:name, :daily_target, :weekly_target, :status)
  end
end

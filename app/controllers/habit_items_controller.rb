class HabitItemsController < ApplicationController
  def create
    @habit_item = HabitItem.create!(habit_item_params)
    @day = day(@habit_item.date)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to habits_path }
    end
  end

  def update
    @habit_item = HabitItem.find(params[:id])
    authorize_user(@habit_item.habit.user_id)

    respond_to do |format|
      if @habit_item.update!(habit_item_params)
        @day = day(@habit_item.date)

        format.turbo_stream
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back, status: :unprocessable_entity }
      end
    end
  end

  private

  def habit_item_params
    params.require(:habit_item).permit(:habit_id, :quantity, :date)
  end

  def day(date)
    Day.find_by_sql(["
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
        days.date = ?
      GROUP BY
        days.date,
        days.total_tasks,
        days.completed_tasks
    ", date]).first
  end
end

class HabitItemsController < ApplicationController
  def update
    @habit_item = HabitItem.find(params[:id])
    authorize_user(@habit_item.habit.user_id)

    respond_to do |format|
      if @habit_item.update!(habit_item_params)
        if @habit_item.date <= today
          @day = Day.find_by_sql(["
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
              days.date
          ", @habit_item.date]).first
        end

        format.turbo_stream
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back, status: :unprocessable_entity }
      end
    end
  end

  private

  def habit_item_params
    params.require(:habit_item).permit(:quantity)
  end
end

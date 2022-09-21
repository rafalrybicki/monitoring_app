class HabitItemsController < ApplicationController
  def update
    @habit_item = HabitItem.find_or_create_by!(date: params[:date], habit_id: params[:habit_id])

    respond_to do |format|
      if @habit_item
        @view = params[:view]
        @daily_target = @habit_item.habit.daily_target

        if params[:type] == 'increment'
          @habit_item.increment!(:quantity)
          session[:day_values]['completed_habits'] += 1 if @daily_target > 0 && @view == 'day'
        elsif params[:type] == 'decrement' && @habit_item.quantity > 0
          @habit_item.decrement!(:quantity)
          session[:day_values]['completed_habits'] -= 1 if @daily_target > 0 && @view == 'day'
        end

        @day = day(@habit_item.date) if @view == 'habits'

        format.turbo_stream
        format.html { redirect_to :back }
      else
        format.html { redirect_to :back, status: :unprocessable_entity }
      end
    end
  end

  private

  def habit_item_params
    params.require(:habit_item).permit(:habit_id, :date, :action)
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

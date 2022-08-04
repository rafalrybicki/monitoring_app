class HabitItemsController < ApplicationController
  def update
    @habit_item = HabitItem.find(params[:id])
    @habit_item.update!(habit_item_params)

    redirect_to habits_path
  end

  # private

  def habit_item_params
    params.require(:habit_item).permit(:quantity)
  end
end

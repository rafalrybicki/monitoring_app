class DaysController < ApplicationController
  before_action :set_day
  before_action :set_tasks

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
    @day = current_user.days.find(date)
  end

  def set_tasks
    @tasks = @day.tasks
  end
end

class DaysController < ApplicationController
  def index; end

  def show
    @day = current_user.days.find_by_date(params[:date])
  end

  def today
    @day = current_user.days.find_by_date(Date.today)
    render :show
  end
end

module ApplicationHelper
  def param_date
    params[:date] ? params[:date].to_date : Date.today
  end
end

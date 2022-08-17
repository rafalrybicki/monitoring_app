module ApplicationHelper
  def param_date
    params[:date] ? params[:date].to_date : Date.today
  end

  def today
    Date.today
  end

  def day_percentage
    return '-' if session[:day_values].nil? # nie zadziała bo bedzeie to na habitah

    total = session[:day_values]['total_tasks'] + session[:day_values]['total_habits']
    completed = session[:day_values]['completed_tasks'] + session[:day_values]['completed_habits']
    completion = (completed / total.to_f) * 100

    (completion == completion.round ? completion.round : completion.round(1)).to_s + '%'
  end

  # def day_percentage(total_tasks, completed_tasks, total_habits, completed_habits)
  #   return '-' if [completed_tasks, completed_habits, total_tasks, total_habits].all?(0)

  #   total = total_tasks + total_habits
  #   completed = completed_tasks + completed_habits
  #   completion = (completed / total.to_f) * 100

  #   (completion == completion.round ? completion.round : completion.round(1)).to_s + '%'
  # end
end

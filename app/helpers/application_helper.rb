module ApplicationHelper
  def render_random_quote
    notice = Quote.order('RANDOM()').first

    if notice
      flash.now[:notice] = notice.content
      turbo_stream.prepend 'flash', partial: 'flash'
    end
  end

  def param_date
    return params[:date].to_date if params[:date]
    return params[:day_date].to_date if params[:day_date]

    Date.today
  end

  def today
    Date.today
  end

  def day_percentage
    percentage(
      session[:day_values]['total_tasks'],
      session[:day_values]['completed_tasks'],
      session[:day_values]['total_habits'],
      session[:day_values]['completed_habits']
    )
  end

  def habit_day_percentage(total_tasks, completed_tasks, total_habits, completed_habits)
    total_habits ||= 0 # because of day model includes total_tasks and completed_tasks
    completed_habits ||= 0

    return '-' if [completed_tasks, completed_habits, total_tasks, total_habits].all?(0)

    percentage(total_tasks, completed_tasks, total_habits, completed_habits)
  end

  private

  def percentage(total_tasks, completed_tasks, total_habits, completed_habits)
    total = total_tasks + total_habits
    completed = completed_tasks + completed_habits
    completion = (completed / total.to_f) * 100

    (completion == completion.round ? completion.round : completion.round(1)).to_s + '%'
  end
end

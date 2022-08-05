module DaysHelper
  def day_percentage(day)
    return '0%' if day.completed_tasks == 0

    percentage = ((day.completed_tasks / day.total_tasks.to_f) * 100)
    percentage = percentage == percentage.round ? percentage.round : percentage.round(1)

    percentage.to_s + '%'
  end
end

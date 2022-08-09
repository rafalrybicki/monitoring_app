module DaysHelper
  def day_title(date)
    date.strftime('%A %-d %B')
  end

  def day_completion(total_tasks, completed_tasks, total_habits, completed_habits)
    return 0 if completed_tasks == 0 && completed_habits == 0

    total = total_tasks + total_habits
    completed = completed_tasks + completed_habits
    completion = (completed / total.to_f) * 100

    completion == completion.round ? completion.round : completion.round(1)
  end
end

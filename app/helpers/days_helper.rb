module DaysHelper
  def day_title(date)
    date.strftime('%A %-d %B')
  end

  def day_habit_css_class(habit)
    return 'success' if habit.quantity >= habit.daily_target
    return 'fail' if habit.quantity < habit.daily_target && habit.date < today
  end
end

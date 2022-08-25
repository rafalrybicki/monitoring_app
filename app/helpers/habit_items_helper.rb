module HabitItemsHelper
  def habit_item_css_class(target, date, habit_item = nil)
    css_class = 'cell'

    return css_class if !habit_item && date == today
    return css_class + ' lightgrey' if !habit_item && date < today

    css_class += ' green' if habit_item.quantity >= target && target > 0
    css_class += ' red' if habit_item.quantity < target

    css_class
  end
end

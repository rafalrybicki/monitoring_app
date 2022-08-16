module HabitItemsHelper
  def habit_item_css_class(target, habit_item = nil)
    return 'lightgrey' unless habit_item
    return '' if habit_item.date == today && target > habit_item.quantity

    css_class = 'green' if habit_item.quantity >= target && target > 0
    css_class = 'red' if habit_item.quantity < target

    css_class
  end
end

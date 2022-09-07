module HabitItemsHelper
  def habit_item_css_class(target, date, quantity)
    css_class = 'cell'

    return css_class + ' monitored' if (target == 0 && date < today) || (target == 0 && quantity.to_i > 0)
    return css_class + ' neutral' if !target && date <= today
    return css_class + ' success' if target && quantity && quantity.to_i > 0 && quantity >= target
    return css_class + ' fail' if target && quantity.to_i < target && date < today

    css_class
  end
end

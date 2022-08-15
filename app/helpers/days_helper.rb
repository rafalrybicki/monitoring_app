module DaysHelper
  def day_title(date)
    date.strftime('%A %-d %B')
  end
end

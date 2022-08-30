module HabitsHelper
  def habit_frequency
    params[:habit][:frequency].reject(&:blank?).map(&:to_i)
  end
end

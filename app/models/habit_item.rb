class HabitItem < ApplicationRecord
  belongs_to :habit
  belongs_to :day, foreign_key: :date, primary_key: :date

  def self.default_scope
    order(:date, :created_at)
  end
end

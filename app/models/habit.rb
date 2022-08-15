class Habit < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'HabitItem' # delete items but only where date >= today
  validates :name, presence: true, length: { minimum: 2 }

  after_create :generate_habit_items

  private

  def generate_habit_items
    start_date = Date.today.beginning_of_month
    end_date = start_date.end_of_month

    (start_date..end_date).each do |date|
      habit_items.create!(date:)
    end
  end
end

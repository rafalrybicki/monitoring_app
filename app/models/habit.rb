class Habit < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'HabitItem' # delete items but only where date >= today
  validates :name, presence: true, length: { minimum: 2 }
end

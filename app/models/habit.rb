class Habit < ApplicationRecord
  belongs_to :user
  has_many :habit_items
end

class Day < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :tasks, foreign_key: :date, primary_key: :date
  has_many :habit_items, foreign_key: :date, primary_key: :date

  self.primary_key = 'date'
end

class Day < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :tasks, foreign_key: :date, primary_key: :date
  has_many :habits, class_name: 'HabitItem', foreign_key: :date, primary_key: :date

  def self.default_scope
    order(:date)
  end

  self.primary_key = 'date'
end

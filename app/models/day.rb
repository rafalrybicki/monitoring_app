class Day < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :tasks, foreign_key: :date, primary_key: :date
  has_many :habit_items, foreign_key: :date, primary_key: :date

  self.primary_key = 'date'

  def completion
    return '0%' if completed_tasks == 0

    percentage = ((completed_tasks / total_tasks.to_f) * 100)
    percentage = percentage == percentage.round ? percentage.round : percentage.round(1)

    percentage.to_s + '%'
  end
end

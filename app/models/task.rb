class Task < ApplicationRecord
  belongs_to :day, foreign_key: :date, primary_key: :date
  belongs_to :user

  validates :content, presence: true, length: { minimum: 2 }

  scope :not_completed, -> { where('date < ? AND completed = ? AND cancelled = ?', Date.today, false, false) }

  def not_today?
    date != Date.today
  end

  def not_completed?
    date < Date.today && completed == false
  end

  def future?
    date > Date.today
  end
end

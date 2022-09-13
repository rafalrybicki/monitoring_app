class Day < ApplicationRecord
  extend FriendlyId
  belongs_to :user, dependent: :destroy
  has_many :tasks, foreign_key: :date, primary_key: :date
  has_many :habits, class_name: 'HabitItem', foreign_key: :date, primary_key: :date
  has_rich_text :summary
  friendly_id :date, use: :slugged

  def self.default_scope
    order(:date)
  end
end

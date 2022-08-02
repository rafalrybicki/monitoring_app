class Task < ApplicationRecord
  belongs_to :day, foreign_key: :date, primary_key: :date
  belongs_to :user
end

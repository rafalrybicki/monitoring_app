class Task < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :day, foreign_key: :date, primary_key: :date
end

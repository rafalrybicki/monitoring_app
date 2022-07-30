class Task < ApplicationRecord
  belongs_to :user, dependent: :destroy
  belongs_to :day
end

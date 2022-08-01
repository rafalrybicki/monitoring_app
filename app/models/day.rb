class Day < ApplicationRecord
  belongs_to :user, dependent: :destroy
  has_many :days, foreign_key: :date, primary_key: :date
end

class Day < ApplicationRecord
  belongs_to :user, dependent: :destroy
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :days, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :habits, dependent: :destroy

  after_create :generate_year

  private

  def generate_year
    today = Date.today

    365.times do |number|
      Day.create!(user_id: id, date: (today + number.days))
    end
  end
end

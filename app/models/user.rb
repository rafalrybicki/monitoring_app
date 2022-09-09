class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :days, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :habits, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :notes, dependent: :destroy

  after_create :generate_year

  private

  def generate_year
    Quote.create!(user_id: id, content: "Just do it, don't wait")
    Quote.create!(user_id: id, content: 'The quicker we begin, the faster we can make a change')
    Quote.create!(user_id: id, content: 'The greater the effort, the bigger the results')
    Quote.create!(user_id: id, content: 'The longer we wait, the harder it will be')
    Quote.create!(user_id: id, content: 'Now is the time to act')
    Quote.create!(user_id: id, content: 'Knowledge is king')

    start_date = Date.current.beginning_of_month

    365.times do |number|
      Day.create!(user_id: id, date: (start_date + number.days))
    end
  end
end

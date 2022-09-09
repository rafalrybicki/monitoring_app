class Note < ApplicationRecord
  belongs_to :user
  has_rich_text :content

  def self.default_scope
    order(:order, :created_at)
  end
end

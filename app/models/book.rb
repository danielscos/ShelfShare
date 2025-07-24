class Book < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :author, presence: true
  validates :condition, presence: true

  scope :available, -> { where(available: true) }
  scope :unavailable, -> { where(available: false) }

  def owner_name
    user.name
  end

  def owner_location
    user.location
  end
end

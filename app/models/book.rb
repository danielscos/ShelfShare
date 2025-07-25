class Book < ApplicationRecord
  belongs_to :user

  validates :title, presence: { message: "Title is required." },
    length: { minimum: 2, maximum: 100, message: "Title must be 2-100 characters." }
  validates :author, presence: { message: "Author is required." },
    length: { minimum: 2, maximum: 50, message: "Author must be 2-50 characters." }
  validates :condition, presence: { message: "Condition is required." },
    inclusion: { in: [ "New", "Good", "Fair", "Poor" ], message: "Condition must be one of New, Good, Fair, or Poor." },
      message: "Condition must be one of New, Good, Fair, or Poor."

  validates :description, length: { maximum: 500, message: "Description cannot exceed 500 characters" }

  validates :available, inclusion: { in: [ true, false ], message: "Availability must be specified" }


  scope :available, -> { where(available: true) }
  scope :unavailable, -> { where(available: false) }

  def owner_name
    user.name
  end

  def owner_location
    user.location
  end
end

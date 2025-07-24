class User < ApplicationRecord
  has_secure_password
  has_many :books, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :location, presence: true

  def admin?
    admin == true
  end

  def make_admin!
    update!(admin: true)
  end

  def remove_admin!
    update!(admin: false)
  end
end

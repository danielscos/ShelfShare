class AdminController < ApplicationController
  before_action :require_admin

  def dashboard
    @total_users = User.count
    @total_books = Book.count
    @available_books = Book.available.count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_books = Book.includes(:user).order(created_at: :desc).limit(5)
  end

  def users
    @users = User.order(:name)
  end

  def books
    @books = Book.includes(:user).order(created_at: :desc)
  end
end

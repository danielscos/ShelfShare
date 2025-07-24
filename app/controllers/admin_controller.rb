class AdminController < ApplicationController
  before_action :require_admin

  def dashboard
    @total_users = User.count
    @total_books = Book.count
    @available_books = Book.available.count
    @admin_users = User.where(admin: true).count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_books = Book.includes(:user).order(created_at: :desc).limit(5)
    @users_with_books = User.joins(:books).distinct.count
    @books_this_week = Book.where("created_at > ?", 1.week.ago).count
  end

  def users
    @users = User.includes(:books).order(:name)
  end

  def books
    @books = Book.includes(:user).order(created_at: :desc)
  end
end

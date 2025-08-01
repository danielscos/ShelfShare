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
    @books_this_week = Book.where("created_at > ?", 1.week.ago).count
    @unique_conditions = Book.distinct.count(:condition)
    @unique_owners = Book.distinct.count(:user_id)
    @available_books_count = Book.available.count
    @unavailable_books_count = Book.where(available: false).count
  end

  def delete_user
    @user = User.find(params[:id])

    if @user == @current_user
      redirect_to admin_users_path, alert: "You cannot delete your own account."
      return
    end

    user_name = @user.name
    user_books_count = @user.books.count

    @user.destroy
    redirect_to admin_users_path, notice: "User '#{user_name}' and their #{user_books_count} books have been deleted."
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, alert: "User not found."
  end
end

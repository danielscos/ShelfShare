class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to ShelfShare! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
    @user_books = @user.books.includes(:user).order(created_at: :desc)
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :location)
  end
end

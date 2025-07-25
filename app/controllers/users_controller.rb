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
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def edit
    @user = User.find(params[:id])
    unless @current_user == @user || admin?
      redirect_to user_path(@user), alert: "Not authorized to edit this profile."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def update
    @user = User.find(params[:id])
    unless @current_user == @user || admin?
      redirect_to user_path(@user), alert: "Not authorized to edit this profile."
      return
    end

    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  private

  def user_params
    permitted_params = [ :name, :email, :location ]

    # Allow password updates only if provided
    if params[:user][:password].present?
      permitted_params += [ :password, :password_confirmation ]
    end

    params.require(:user).permit(permitted_params)
  end
end

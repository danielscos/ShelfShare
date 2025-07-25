class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :edit, :update ]
  before_action :require_owner_or_admin, only: [ :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    begin
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_path, notice: "Welcome to ShelfShare, #{@user.name}! Your account has been created successfully."
      else
        # Log validation errors
        Rails.logger.warn "User registration failed: #{@user.errors.full_messages.join(', ')}"

        # Render form with errors
        flash.now[:alert] = "Please fix the errors below to create your account."
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      # Handle unique constraint violations (like duplicate email)
      @user.errors.add(:email, "is already taken")
      flash.now[:alert] = "This email address is already registered."
      render :new, status: :unprocessable_entity
    rescue StandardError => e
      # Handle any other unexpected errors
      Rails.logger.error "Unexpected error creating user: #{e.message}"
      flash.now[:alert] = "An unexpected error occurred. Please try again."
      render :new, status: :internal_server_error
    end
  end

  def show
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def edit
    unless @current_user == @user || admin?
      redirect_to user_path(@user), alert: "Not authorized to edit this profile."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def update
    unless @current_user == @user || admin?
      redirect_to user_path(@user), alert: "Not authorized to edit this profile."
      return
    end

    begin
      if @user.update(user_params)
        redirect_to @user, notice: "Profile updated successfully!"
      else
        # Log validation errors
        Rails.logger.warn "User update failed for ID #{@user.id}: #{@user.errors.full_messages.join(', ')}"

        # Render form with errors
        flash.now[:alert] = "Please fix the errors below to update your profile."
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      # Handle unique constraint violations
      @user.errors.add(:email, "is already taken")
      flash.now[:alert] = "This email address is already in use."
      render :edit, status: :unprocessable_entity
    rescue StandardError => e
      # Handle any other unexpected errors
      Rails.logger.error "Unexpected error updating user ID #{@user.id}: #{e.message}"
      flash.now[:alert] = "An unexpected error occurred. Please try again."
      render :edit, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "User not found."
  end

  def require_owner_or_admin
    unless @current_user == @user || admin?
      redirect_to user_path(@user), alert: "Not authorized."
    end
  end

  def user_params
    permitted_params = [ :name, :email, :location ]

    # Allow password updates only if provided
    if params[:user][:password].present?
      permitted_params += [ :password, :password_confirmation ]
    end

    params.require(:user).permit(permitted_params)
  rescue ActionController::ParameterMissing => e
    Rails.logger.warn "Missing required parameters: #{e.message}"
    redirect_to users_path, alert: "Invalid form submission. Please try again."
  end
end

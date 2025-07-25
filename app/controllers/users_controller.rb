def create
  @user = User.new(user_params)

  begin
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Welcome to ShelfShare, #{@user.name}! Your account has been created successfully."
    else
      # log validation errors
      Rails.logger.warn "User registration failed: #{@user.errors.full_messages.join(', ')}"

      # render form with errors
      flash.now[:alert] = "Please fix the errors below to create your account."
      render :new, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    # handle unique constraint violations
    @user.errors.add(:email, "is already taken")
    flash.now[:alert] = "This email address is already registered."
    render :new, status: :unprocessable_entity
  rescue StandardError => e
    # handle any other unexpected errors
    Rails.logger.error "Unexpected error creating user: #{e.message}"
    flash.now[:alert] = "An unexpected error occurred. Please try again."
    render :new, status: :internal_server_error
  end
end

def update
  begin
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully!"
    else
      # log validation errors
      Rails.logger.warn "User update failed for ID #{@user.id}: #{@user.errors.full_messages.join(', ')}"

      # render form with errors
      flash.now[:alert] = "Please fix the errors below to update your profile."
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    # handle unique constraint violations
    @user.errors.add(:email, "is already taken")
    flash.now[:alert] = "This email address is already in use."
    render :edit, status: :unprocessable_entity
  rescue StandardError => e
    # handle any other unexpected errors
    Rails.logger.error "Unexpected error updating user ID #{@user.id}: #{e.message}"
    flash.now[:alert] = "An unexpected error occurred. Please try again."
    render :edit, status: :internal_server_error
  end
end

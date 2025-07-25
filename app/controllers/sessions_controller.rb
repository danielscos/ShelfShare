class SessionsController < ApplicationController
  def new
    # Login form - no logic needed, just renders the form
  end

  def create
    # Find user by checking both encrypted and plain email formats
    user = User.all.find do |u|
      u.real_email_for_owner == params[:email]
    end

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Successfully logged in!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Successfully logged out!"
  end
end

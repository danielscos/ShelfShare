class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :current_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to login_path, alert: "You must be logged in to access this page." unless @current_user
  end

  def logged_in?
    !!@current_user
  end

  def admin?
    logged_in? && @current_user.admin?
  end

  def require_admin
    redirect_to root_path, alert: "Access denied. Admin privileges required." unless admin?
  end

  helper_method :current_user, :logged_in?, :admin?
end

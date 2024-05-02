class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :set_current_user
  helper_method :logged_in?

  before_action :require_login

  def current_user
    id = request.headers["X-User-Id"] || session[:user_id]
    @current_user ||= User.find(id) if id
  end

  def set_current_user(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !!current_user
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end

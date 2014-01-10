class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :currently_signed_in?

  def current_user
    return User.find(session[:user_id]) if session[:user_id]
    nil
  end

  def currently_signed_in?(user)
    current_user == user
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :current_view, :logged_in?

  def current_view
    @current_view
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]  
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:danger] = "Ingresa al sistema para realizar esa acción"
      redirect_to login_path
    end
  end
  
   def true?(obj)
     obj.to_s == "true"
   end

end

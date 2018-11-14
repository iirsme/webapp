class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to root_path
    end
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      # flash[:success] = "You have successfully logged in"
      redirect_to root_path
    else
      flash.now[:danger] = "El email o contraseña son incorrectos"
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    # flash[:success] = "You have successfully logged out"
    render 'new'
  end
end
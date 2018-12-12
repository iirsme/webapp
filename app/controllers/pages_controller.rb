class PagesController < ApplicationController
  def home
    @current_view = 'home'
    if !logged_in?
      redirect_to login_path
      return
    end
    redirect_to roles_path # researches_path
  end
end
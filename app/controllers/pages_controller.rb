class PagesController < ApplicationController
  def home
    @current_view = 'home'
    # redirect_to roles_path if logged_in?
  end
end
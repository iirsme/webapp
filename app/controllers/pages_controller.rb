class PagesController < ApplicationController
  def home
    @current_view = 'home'
    if !logged_in?
      redirect_to login_path
      return
    end
    @researches = Research.all
  end
end
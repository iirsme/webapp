class PagesController < ApplicationController
  def home
    @current_view = 'home'
    if !logged_in?
      redirect_to login_path
      return
    end
    # redirect_to researches_path
    @researches = Research.all
  end
end
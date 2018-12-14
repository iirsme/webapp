class ResearchesController < ApplicationController
  before_action :set_current_view
  before_action :set_research, only: [:edit, :update, :show, :destroy]
  before_action :require_user
  
  private
  def set_current_view
    @current_view = 'researches'
  end
  def set_research
    @research = Research.find(params[:id])
  end
  def research_params
    # params.require(:research).permit(:username, :email, :firstname, :lastname, :password, :is_admin)
  end

end
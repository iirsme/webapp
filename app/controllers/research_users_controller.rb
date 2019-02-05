class ResearchUsersController < ApplicationController

  def get_research_users
    @users = ResearchUser.where(research: params[:research_id])
    respond_to do |format|
      format.js { render partial: 'research_users/form', users: @users }
    end
  end

end
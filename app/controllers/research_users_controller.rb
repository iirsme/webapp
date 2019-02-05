class ResearchUsersController < ApplicationController

  def get_research_users
    research_id = params[:research_id]
    @users = ResearchUser.all_research_users(research_id)
    respond_to do |format|
      format.js { render partial: 'research_users/get_users', users: @users }
    end
  end

  def add_research_user
    user_id = params[:research_user][:user_id]
    role_id = params[:research_user][:role_id]
    research_id = params[:research_id]
    @ru = ResearchUser.new(user_id: user_id, role_id: role_id, research_id: research_id)
    if @ru.save
      @users = ResearchUser.all_research_users(research_id)
      respond_to do |format|
        format.js { render partial: 'research_users/refresh_users', users: @users }
      end
    end
    puts @ru.errors.full_messages
  end
  
  def delete_research_user
    research_id = params[:research_id]
    record = params[:record]
    ru = ResearchUser.where(id: record).first
    ru.destroy
    respond_to do |format|
      @users = ResearchUser.all_research_users(research_id)
      format.js { render partial: 'research_users/refresh_users', users: @users }
    end
  end

end
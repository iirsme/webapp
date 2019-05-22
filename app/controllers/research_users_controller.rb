class ResearchUsersController < ApplicationController

  def get_research_users
    research_id = params[:research_id]
    @research = Research.find(params[:research_id])
    @research.id? # Raise intentionally an error if nil
    @users = ResearchUser.all_research_users(research_id)
    respond_to do |format|
      format.js { render partial: 'research_users/get_users', users: @users }
    end
  end

  def add_research_user
    user_id = params[:research_user][:user_id]
    role_id = params[:research_user][:role_id]
    research_id = params["u_research_id"]

    if user_id.blank? || role_id.blank?
      @title = "Usuario y Rol son campos necessarios para agregar un nuevo Usuario"
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end

    @ru = ResearchUser.new(user_id: user_id, role_id: role_id, research_id: research_id)
    if @ru.save
      @users = ResearchUser.all_research_users(research_id)
      @title = "Usuario agregado al Protocolo exitosamente"
      @is_error = false
      respond_to do |format|
        format.js { render partial: 'research_users/refresh_users', users: @users }
      end
      return
    else
      @title = @ru.errors.messages[:user][0]
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end
  end

  def delete_research_user
    research_id = params[:research_id]
    record = params[:record]
    ru = ResearchUser.where(id: record).first
    ru.destroy
    @users = ResearchUser.all_research_users(research_id)
    @title = "Usuario eliminado del Protocolo exitosamente"
    @is_error = false
    respond_to do |format|
      format.js { render partial: 'research_users/refresh_users', users: @users }
    end
  end

end
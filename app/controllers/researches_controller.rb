class ResearchesController < ApplicationController
  before_action :set_current_view
  before_action :set_research, only: [:edit, :update, :show, :destroy]
  before_action :require_user

  def enter_research
    # render plain: params.inspect
    seq_no = ""
    params.each do |key, value|
      if key.start_with?("seqno_")
        seq_no = value
      end
    end
    id = params["id_" + seq_no]
    password = params["password_" + seq_no]

    @research = Research.find(id)
    if @research.is_private
      if !@research.correct_password?(password)
        flash[:danger] = "Contraseña incorrecta"
        redirect_to home_path and return
      elsif !@research.authorized_user?(current_user)
        flash[:danger] = "Acceso denegado, favor de contactar al administrador del protocolo"
        redirect_to home_path and return
      end
    end
    redirect_to research_path(@research)
  end

  def show

  end

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
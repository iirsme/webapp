class ResearchesController < ApplicationController
  before_action :require_user
  before_action :set_research, only: [:edit, :update, :show, :destroy, :get_report]
  before_action :set_current_research, except: [:back, :get_report]
  before_action only: [:edit, :update, :destroy] do
    require_owner(@research)
  end
  before_action only: [:show] do
    require_research_user(@research)
  end

  def get_report
    @appts = params['appts_no'].split(",")
    @records = Appointment.includes(patient: :candidate)
    .where("appointments.appt_no IN (?) AND appointments.status = 'Completada'", @appts)
    .order("candidates.curp, appointments.appt_no ASC")

    respond_to do |format|
      format.xlsx
    end
  end

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
    if !is_super_admin?
      if @research.is_private
        if !@research.correct_password?(password)
          flash[:danger] = "Contraseña incorrecta"
          redirect_to home_path and return
        elsif !@research.authorized_user?(current_user)
          flash[:danger] = "Acceso denegado, favor de contactar al administrador del protocolo."
          redirect_to home_path and return
        end
      end
    end

    if @research.is_ready
      redirect_to research_path(@research)
    else
      if @current_user.owner?(@research) || is_super_admin?
        redirect_to edit_research_path(@research)
      else
        flash[:danger] = "Acceso denegado. El Protocolo al que quiere ingresar esta deshabilitado termporalmente."
        redirect_to home_path and return
      end
    end
  end

  def get_summary
    @research = Research.find(params[:research_id])
    step1 = @research.id? #Raise intentionally an error if nil
    step2 = @research.tabs.length > 0 && @research.fields.length > 0
    step3 = @research.users.length > 0
    @summary = [step1, step2, step3]
    @ready = step1 && step2 && step3

    respond_to do |format|
      format.js { render partial: 'researches/summary/get_summary' }
    end
  end

  def show
    @available_candidates = Candidate.where("id NOT IN (SELECT candidate_id FROM patients WHERE research_id = ?)", @research.id).order(curp: :asc);
  end

  def new
    @current_step = 1
    @research = Research.new
  end

  def create
    @current_step = 1
    @research = Research.new(research_params) 
    if @research.save
      # flash[:success] = "Protocolo creado satisfactoriamente"
      redirect_to edit_research_path(@research)
    else
      render 'new'
    end
  end

  def edit
    @current_step = 1
    @current_view = 'research-setup'
  end

  def update
    @current_step = 1
    params = research_params
    is_ready = params[:is_ready]
    if is_ready.blank?
      params.delete(:password) if params[:password] == Research::TEMP_PASSWORD
      if @research.update(params)
        redirect_to edit_research_path(@research)
      else
        render 'edit'
      end
    else
      if @research.update(params) && ActiveModel::Type::Boolean.new.cast(is_ready) 
        redirect_to research_path(@research)
      else
        render 'edit'
      end
    end
  end
  
  def back
    research = params[:research]
    go_home = true?(params[:go_home])
    if go_home
      redirect_to home_path
    else
      @current_research = Research.find(research)
      redirect_to research_path(@current_research)
    end
  end

  def destroy
    ResearchUser.where(research_id: @research.id).delete_all # Delete Research Users
    ResearchField.where(research_id: @research.id).delete_all # Delete Research Fields
    Tab.where(research_id: @research.id).delete_all # Delete Tabs

    appts = Appointment.where(research_id: @research.id)
    appts.each do |a|
      Audit.where(record_id: a.id).delete_all # Delete Audits
    end

    appts.delete_all # Delete Appointments
    Patient.where(research_id: @research.id).delete_all # Delete Patients
    @research.destroy # Delete the Research

    flash[:success] = "Protocolo eliminado satisfactoriamente"
    redirect_to home_path
  rescue ActiveRecord::InvalidForeignKey
    @current_step = 1
    flash[:danger] = "Error al eliminar el Protocolo. No se pudieron eliminar todas las referencias."
    redirect_to edit_research_path(@research)
  end

  private
  def set_research
    @research = Research.find(params[:id])
  end
  def set_current_research
    @current_research = @research
  end
  def research_params
    params.require(:research).permit(:code, :name, :description, :is_private, :password, :registration_code, :owner_id, :is_ready)
  end

end
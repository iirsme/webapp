class AppointmentsController < ApplicationController
  before_action :set_current_view
  before_action :set_current_research
  before_action :set_appointment, only: [:edit, :update, :destroy]
  before_action do
    require_research_user(@current_research)
  end
  before_action only: [:index, :new, :create, :edit, :update, :destroy, :add_patient_appt, :delete_patient_appt] do
    can_user_perform_action(@current_user, @current_research, action_name)
  end

  def add_patient_appt
    @appt = Appointment.new(patient_id: params[:patient_id], research_id: params[:research_id], appt_no: params[:appt_no], 
                            status: params[:status], appt_date: params[:appt_date], appt_time: params[:appt_time], notes: params[:notes])
    @appt.current_user = current_user
    if @appt.save
      @appts = Appointment.all_patient_appts(@appt.patient.id)
      respond_to do |format|
        format.js { render partial: 'patients/appts' }
      end
    else

    end
  end

  def delete_patient_appt
    record = params[:record]
    @appt = Appointment.where(id: record).first
    @appt.current_user = current_user
    patient = @appt.patient
    if @appt.destroy
      @appts = Appointment.all_patient_appts(patient.id)
      respond_to do |format|
        format.js { render partial: 'patients/appts' }
      end
    else
      # TODO: Fix/add errors management
    end
  end

  def index
    @appointments = Appointment.where(research_id: @current_research.id).order(appt_date: :asc, appt_time: :asc)
  end

  def new
    @appointment = Appointment.new
    @comesFrom = params[:comesFrom]
    @appointment.research = @current_research
    @patients = Patient.all.order('candidate.curp ASC');
  end

  def create
    @comesFrom = params[:comesFrom]
    @appointment = Appointment.new(appointment_params)
    @appointment.current_user = current_user
    if @appointment.save
      flash[:success] = "Visita creada satisfactoriamente"
      redirect_to appointments_path(research_id: @current_research.id)
    else
      render 'new'
    end
  end

  def edit
    @comesFrom = params[:comesFrom]
  end

  def update
    @appointment.current_user = current_user
    @comesFrom = params[:comesFrom]
    @appointment.is_evaluation = !appointment_params[:values].blank?
    if @appointment.is_evaluation
      if @appointment.update(appointment_params)
        flash[:success] = "Evaluación actualizada satisfactoriamente"
        redirect_to see_evaluation_path(id: @appointment, research_id: @current_research, comesFrom: @comesFrom)
      end
    else
      if @appointment.update(appointment_params)
        flash[:success] = "Visita actualizada satisfactoriamente"
        if @comesFrom == "appointments"
          redirect_to appointments_path(research_id: @current_research.id)
        else
          redirect_to edit_patient_path(@appointment.patient, research_id: @current_research.id)
        end
      else
        render 'edit'
      end
    end
  end

  def destroy
    @appointment.current_user = current_user
    @appointment.destroy
    flash[:success] = "Visita eliminada satisfactoriamente del protocolo"
    redirect_to appointments_path(research_id: @current_research)
  end


  private
  def set_current_view
    @current_view = 'appointments'
  end
  def set_current_research
    @current_research = Research.find(params[:research_id])
  end
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end
  def appointment_params
    params.require(:appointment).permit(:patient_id, :research_id, :appt_no, :status, :appt_date, :appt_time, :notes, values: {})
  end
end
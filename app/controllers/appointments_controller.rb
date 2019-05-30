class AppointmentsController < ApplicationController
  before_action :set_current_view
  before_action :set_current_research, only: [:index, :edit, :new, :update, :show, :destroy]
  before_action :set_appointment, only: [:edit, :update, :show, :destroy]
  before_action only: [:index, :edit, :update, :show, :destroy] do
    require_research_user(@current_research)
  end

  def add_patient_appointment
    @appt = Appointment.new(patient_id: params[:patient_id], research_id: params[:research_id], appt_no: params[:appt_no], 
                            status: params[:status], appt_date: params[:appt_date], appt_time: params[:appt_time], notes: params[:notes])
    if @appt.save
      @appts = Appointment.all_patient_appts(@appt.patient.id)
      respond_to do |format|
        format.js { render partial: 'patients/appts' }
      end
    else

    end
  end

  def delete_patient_appointment
    record = params[:record]
    appt = Appointment.where(id: record).first
    patient = appt.patient
    if appt.destroy
      @appts = Appointment.all_patient_appts(patient.id)
      respond_to do |format|
        format.js { render partial: 'patients/appts' }
      end
    else
      # TODO: Fix/add errors management
    end
  end

  def index
    @appointments = Appointment.where(research_id: @current_research.id)
  end

  def new
    @appointment = Appointment.new
    @appointment.research = @current_research
    @patients = Patient.all.order('candidate.curp ASC');
  end

  def destroy
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
    params.require(:appointment).permit(:patient_id, :research_id, :appt_no, :status, :appt_date, :appt_time, :notes)
  end
end
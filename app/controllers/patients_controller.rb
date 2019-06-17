class PatientsController < ApplicationController
  before_action :set_current_view
  before_action :set_current_research
  before_action :set_patient, only: [:edit, :update, :show, :destroy]
  before_action only: [:index, :edit, :update, :show, :destroy] do
    require_research_user(@current_research)
  end

  def index
    @patients = Patient.where(research_id: @current_research.id)
  end

  def new
    @patient = Patient.new
    @patient.research = @current_research
    @available_candidates = Candidate.where("id NOT IN (SELECT candidate_id FROM patients WHERE research_id = ?)", @current_research.id).order(curp: :asc);
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.research = @current_research
    if @patient.save
      flash[:success] = "Paciente agregado al protocolo satisfactoriamente"
      redirect_to edit_patient_path(@patient, research_id: @current_research)
    else
      @available_candidates = Candidate.where("id NOT IN (SELECT candidate_id FROM patients WHERE research_id = ?)", @current_research.id).order(curp: :asc);
      render 'new'  
    end
  end

  def destroy
    @patient.destroy
    flash[:success] = "Paciente eliminado satisfactoriamente del protocolo"
    redirect_to patients_path(research_id: @current_research)
  rescue ActiveRecord::InvalidForeignKey
    flash[:danger] = "Este paciente no puede ser eliminado ya que contiene 1 o más Visitas"
    redirect_to patients_path(research_id: @current_research)
  end

  def edit
    @available_candidates = Candidate.where("id NOT IN (SELECT candidate_id FROM patients WHERE research_id = ? AND candidate_id <> ?)", @current_research.id, @patient.candidate.id).order(curp: :asc);
    @appts = Appointment.all_patient_appts(@patient.id)
  end
  
  def update
    if @patient.update(patient_params)
      flash[:success] = "Paciente actualizado satisfactoriamente"
    end
    redirect_to edit_patient_path(@patient, research_id: @current_research) # TODO: Fix/add errors management
  end
  

  private
  def set_current_view
    @current_view = 'patients'
  end
  def set_current_research
    @current_research = Research.find(params[:research_id])
  end
  def set_patient
    @patient = Patient.find(params[:id])
  end
  def patient_params
    params.require(:patient).permit(:candidate_id)
  end
end
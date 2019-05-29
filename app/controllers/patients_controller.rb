class PatientsController < ApplicationController
  before_action :set_current_view
  before_action :set_patient, only: [:edit, :update, :show, :destroy]
  before_action :set_current_research
  before_action only: [:edit, :update, :show, :destroy] do
    require_research_user(@current_research)
  end

  def index
    @patients = Patient.where(research_id: @current_research.id)
  end

  def new
    @patient = Patient.new
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.research = @current_research
    if @patient.save
      flash[:success] = "Paciente agregado al protocolo satisfactoriamente"
      redirect_to edit_patient_path(@patient)
    else
      render 'new'
    end
  end

  def destroy
    @patient.destroy
    flash[:success] = "Paciente eliminado satisfactoriamente del protocolo"
    redirect_to patients_path(research_id: @current_research)
  end

  def edit
  end

  private
  def set_current_view
    @current_view = 'patients'
  end
  def set_current_research
    puts "******* #{params}"
    @current_research = Research.find(params[:research_id])
  end
  def set_patient
    @patient = Patient.find(params[:id])
  end
  def patient_params
    params.require(:patient).permit(:candidate_id)
  end
end
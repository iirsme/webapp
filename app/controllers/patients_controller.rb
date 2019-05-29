class PatientsController < ApplicationController
  before_action :set_current_view
  before_action :set_patient, only: [:edit, :update, :show, :destroy]
  before_action :set_current_research

  def index
    @patients = Patient.where(research_id: @current_research.id)
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
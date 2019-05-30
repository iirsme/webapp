class EvaluationsController < ApplicationController
  before_action :set_current_view
  before_action :set_current_research
  before_action :set_appointment, only: [:show]

  def show
  end

  private
  def set_current_view
    @current_view = 'appointments'
  end
  def set_current_research
    @current_research = Research.find(params[:research_id])
  end
  def set_appointment
    @appoitment = Appointment.find(params[:id])
  end
end
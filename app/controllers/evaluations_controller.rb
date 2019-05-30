class EvaluationsController < ApplicationController
  before_action :set_current_view
  before_action :set_current_research
  before_action :set_appointment, only: [:show]
  before_action only: [:show] do
    require_research_user(@current_research)
  end

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
    @appointment = Appointment.find(params[:id])
  end
end
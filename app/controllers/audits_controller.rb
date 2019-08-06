class AuditsController < ApplicationController
  before_action :require_user
  before_action :set_current_research
  before_action only: [:get_audit] do
    can_user_perform_action(@current_user, @current_research, action_name)
  end

  def get_audit
    @audit = Audit.get_audit(params[:record_id], params[:record_type], params[:from], params[:to])
    respond_to do |format|
      format.js { render partial: 'log' }
    end
  end

  private
  def set_current_research
    @current_research = Research.find(params[:research_id])
  end
  
end
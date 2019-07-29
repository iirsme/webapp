class AuditsController < ApplicationController
  before_action :require_user

  def get_audit
    @audit = Audit.get_audit(params[:record_id], params[:record_type], params[:from], params[:to])
    respond_to do |format|
      format.js { render partial: 'log' }
    end
  end
  
end
class ReportsController < ApplicationController
    before_action :set_current_view
    before_action :require_user
    before_action :require_admin

    def index
    end

    def get_report
      @researches = params['research_id']
      @status = params['status']
      @add_status_column = !@status.nil? && @status.length > 1
      @records = Appointment.includes(:research, patient: :candidate)
      .where("appointments.research_id IN (?) AND appointments.status IN (?)", @researches, @status)
      .order("candidates.name, candidates.last_name1, researches.code, appointments.appt_no ASC")

      respond_to do |format|
        format.xlsx
      end
    end

    private
    def set_current_view
      @current_view = 'database_report'
    end
end
class ReportsController < ApplicationController
    before_action :set_current_view
    before_action :require_user
    before_action :require_admin

    def index
    end

    def get_report
      @researches = params['research_id'].split(",")
      @status = params['status'].split(",")

      respond_to do |format|
        format.xlsx
      end
    end

    private
    def set_current_view
      @current_view = 'database_report'
    end
end
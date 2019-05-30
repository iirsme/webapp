class AppointmentsController < ApplicationController

  def add_patient_appointment
    puts "*************** #{params}"
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

end
class Appointment < ApplicationRecord
  belongs_to :research
  belongs_to :patient
  
  validates :appt_date, presence: { message: "Fecha no puede ir vacio." }
  validates :appt_time, presence: { message: "Hora no puede ir vacio." }
  validates :status, presence: { message: "Status no puede ir vacio." }
  
  def self.all_patient_appts(patient_id)
    appts = self.where(patient: patient_id).order(appt_date: :asc, appt_time: :asc )
  end

end
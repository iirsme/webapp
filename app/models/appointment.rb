class Appointment < ApplicationRecord
  belongs_to :research
  belongs_to :patient
  
  validates :appt_date, presence: { message: "Fecha no puede ir vacio." }
  validates :appt_time, presence: { message: "Hora no puede ir vacio." }
  validates :status, presence: { message: "Status no puede ir vacio." }

end
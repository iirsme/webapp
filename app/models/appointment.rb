class Appointment < ApplicationRecord
  attr_accessor :current_user # For Audit purposes

  belongs_to :research
  belongs_to :patient
  serialize :values, Hash

  after_create :insert_log
  #before_update :update_log
  before_destroy :delete_log

  validates :patient, presence: {message: "Paciente no puede ir vacio"}
  validates :appt_date, presence: { message: "Fecha no puede ir vacio." }
  validates :appt_time, presence: { message: "Hora no puede ir vacio." }
  validates :status, presence: { message: "Status no puede ir vacio." }

  def insert_log
    log = []
    Audit.track_change(self.id, self.class.name.downcase, 'I', current_user.id, log.to_json)
  end

  def delete_log
    log = []
    Audit.track_change(self.id, self.class.name.downcase, 'D', current_user.id, log.to_json)
  end

  def self.all_patient_appts(patient_id)
    appts = self.where(patient: patient_id).order(appt_date: :asc, appt_time: :asc )
  end

  def get_type
    return self.class.name.downcase
  end

end
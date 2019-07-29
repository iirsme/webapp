class Appointment < ApplicationRecord
  attr_accessor :current_user # For Audit purposes
  attr_accessor :is_evaluation # For Audit purposes

  belongs_to :research
  belongs_to :patient
  serialize :values, Hash

  after_create :insert_log
  before_update :update_log
  before_destroy :delete_log

  validates :patient, presence: { message: "Paciente no puede ir vacio" }
  validates :appt_date, presence: { message: "Fecha no puede ir vacio." }
  validates :appt_time, presence: { message: "Hora no puede ir vacio." }
  validates :status, presence: { message: "Status no puede ir vacio." }

  def insert_log
    log = []
    Audit.track_change(self.id, self.get_type, 'I', current_user.id, log.to_json)
  end

  def insert_eval_log
    log = []
    Audit.track_change(self.id, self.get_eval_type, 'I', current_user.id, log.to_json)
  end

  def update_log
    log = []
    type = is_evaluation ? self.get_eval_type : self.get_type

    if is_evaluation
      prev_audits = Audit.find_by_type(self.id, type)
      if prev_audits.size == 0
        insert_eval_log
        return
      else
        log = update_eval_log
      end
    else
      log = update_appt_log
    end

    Audit.track_change(self.id, type, 'U', current_user.id, log.to_json)
  end

  def delete_log
    log = []
    Audit.track_change(self.id, self.get_type, 'D', current_user.id, log.to_json)
    Audit.track_change(self.id, self.get_eval_type, 'D', current_user.id, log.to_json)
  end

  def update_eval_log
    return []
  end

  def update_appt_log
    return []
  end

  def self.all_patient_appts(patient_id)
    appts = self.where(patient: patient_id).order(appt_date: :asc, appt_time: :asc )
  end

  def get_type
    return self.class.name.downcase
  end
  
  def get_eval_type
    return 'evaluation'
  end

end
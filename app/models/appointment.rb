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
    Appointment.columns.each do |c|
      att = c.name
      if !self[att].blank? && !Audit.is_excluded_att?(att)
        old_value = ""
        new_value = self[att]
        log << { :column => att, :old_value => old_value, :new_value => new_value }
      end
    end
    Audit.track_change(self.id, self.get_type, 'I', current_user.id, log.to_json)
    Audit.track_change(self.id, self.get_eval_type, 'I', current_user.id, [].to_json)
  end

  def update_log
    log = []
    type = is_evaluation ? self.get_eval_type : self.get_type
    if is_evaluation
      log = update_eval_log
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
    log = []
    if self.attribute_changed?('values')
      old_values = self.attribute_was('values')
      new_values = self['values']

      new_values.each do |key, value|
        new_value = value
        old_value = old_values.has_key?(key) ? old_values[key] : ""
        
        if old_value != new_value
          field = Field.find_by_name(key)
          if field.field_type == 'check_box'
            new_value = new_value.to_i.zero? ? "No" : "Si"
            old_value = old_value.to_i.zero? ? "No" : "Si"
          elsif field.field_type == 'select'
            new_value = field.get_value(new_value)
            old_value = field.get_value(old_value)
          elsif field.field_type == 'multi_select'
            new_value = field.get_values(new_value)
            old_value = field.get_values(old_value)
          end
          log << { :column => key, :old_value => old_value, :new_value => new_value }
        end
      end
      
    end
    return log
  end

  def update_appt_log
    log = []
    Appointment.columns.each do |c|
      att = c.name
      if self.attribute_changed?(att) && !Audit.is_excluded_att?(att)
        old_value = self.attribute_was(att)
        new_value = self[att]
        log << { :column => att, :old_value => old_value, :new_value => new_value }
      end
    end
    return log
  end

  def self.all_patient_appts(patient_id)
    appts = self.where(patient: patient_id).order(appt_date: :asc, appt_time: :asc )
  end

  def self.get_last_added_appts_by_research(research_id, limit)
    self.includes(patient: :candidate)
    .where(research_id: research_id)
    .order("appointments.created_at DESC")
    .limit(limit)
  end

  def get_type
    return self.class.name.downcase
  end
  
  def get_eval_type
    return 'evaluation'
  end

end
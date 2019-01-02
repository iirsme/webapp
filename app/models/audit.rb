class Audit < ApplicationRecord
  belongs_to :user
  
  def get_action
    action = ""
    if (self.action == 'I')
      action = "Creado"
    elsif (self.action == 'U')
      action = "Actualizado"
    else
      action = "Eliminado"
    end
  end
  
  def self.track_change(record_id, entity, action, user, log)
    create(record_id: record_id, entity: entity, action: action, user_id: user, done_at: Time.current, log: log)
  end

  def self.get_audit(record_id, from, to)
    # from_date = Date.strptime(from, '%d-%m-%Y')
    # to_date = Date.strptime(to, '%d-%m-%Y')
    Audit.where(record_id: record_id, done_at: from..to).order(done_at: :asc)
  end

end
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

  def self.get_audit(record_id, record_type, from, to)
    from_date = (from + ' 00:00:00') unless from.blank?
    to_date = (to + ' 23:59:59') unless to.blank?
    where(record_id: record_id, done_at: from_date..to_date).order(done_at: :asc)
  end

  def self.find_by_type(record_id, entity)
    where(record_id: record_id, entity: entity)
  end

end
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

  def self.get_values_as_string(values)
    result = ""
    return result unless !values.nil?

    no_values = values.length
    values.each_with_index do |id, idx|
      if !id.empty?
        result = result + "" + Candidate.get_map_value(id)
        if idx < no_values - 1
          result = result + ", "
        end
      end
    end
    return result
  end
  
  def self.track_change(record_id, entity, action, user, log)
    create(record_id: record_id, entity: entity, action: action, user_id: user, done_at: Time.current, log: log)
  end

  def self.get_audit(record_id, from, to)
    from_date = (from + ' 00:00:00') unless from.blank?
    to_date = (to + ' 23:59:59') unless to.blank?
    Audit.where(record_id: record_id, done_at: from_date..to_date).order(done_at: :asc)
  end

end
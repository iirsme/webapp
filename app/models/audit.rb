class Audit < ApplicationRecord
  belongs_to :user
  
  def self.track_change(record_id, entity, action, user, log)
    create(record_id: record_id, entity: entity, action: action, user_id: user, done_at: Time.current, log: log)
  end

end
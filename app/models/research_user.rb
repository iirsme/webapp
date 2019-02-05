class ResearchUser < ApplicationRecord
  belongs_to :user
  belongs_to :research
  belongs_to :role

  validates :user, uniqueness: { scope: :research, 
                                 message: "Este Usuario ya es parte de este Protocolo" }

  def self.new_record(user, research, role, is_owner)
    new(user: user, research: research, role: role, is_owner: is_owner)
  end

  def self.get_record(user, research)
    where(user: user, research: research).first
  end

  def self.delete_record(research)
    record = where(is_owner: true, research: research).first
    record.delete unless record.blank?
  end

  def self.update_role(record, role, is_owner)
    record.role = role
    record.is_owner = is_owner
    record.save
  end

  def self.all_research_users(research_id)
    users = self.where(research: research_id).order(is_owner: :desc)
  end

end
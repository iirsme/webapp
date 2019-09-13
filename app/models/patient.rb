class Patient < ApplicationRecord
  belongs_to :research
  belongs_to :candidate
  has_many :appointments

  validates :candidate, presence: {message: "Candidato no puede ir vacio"},
                        uniqueness: { scope: :research, 
                                      message: "Este Candidato ya es paciente de este Protocolo" }

  def get_identifier
    ide = self.candidate.get_identifier
  end

  def self.get_patients_by_research(research_id)
    self.includes(:candidate)
    .where(research_id: research_id)
    .order("candidates.curp ASC, candidates.hospital_record ASC")
  end

  def self.get_last_added_patients_by_research(research_id, qty)
    self.includes(:candidate)
    .where(research_id: research_id)
    .order("patients.created_at DESC")
    .limit(10)
  end

end
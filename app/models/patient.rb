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
    self.where(research_id: research_id).order(candidate_id: :asc) # TODO: Order by candidate.CURP
  end

end
class Patient < ApplicationRecord
  belongs_to :research
  belongs_to :candidate

  validates :candidate, uniqueness: { scope: :research, 
                                      message: "Este Candidato ya es paciente de este Protocolo" }

end
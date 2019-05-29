class Patient < ApplicationRecord
  belongs_to :research
  belongs_to :candidate
  has_many :appointments
  
  validates :candidate, presence: {message: "Candidato no puede ir vacio"},
                        uniqueness: { scope: :research, 
                                      message: "Este Candidato ya es paciente de este Protocolo" }

end
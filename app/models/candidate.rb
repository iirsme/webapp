class Candidate < ApplicationRecord
  before_save :clear_other_occupation
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :curp, presence: { message: "CURP no puede ir vacio" }
  validates :name, presence: { message: "Nombre no puede ir vacio" }
  validates :last_name1, presence: { message: "Al menos un Apellido debe de registrarse" }
  validates :occupation_other, if: :requires_occupation?, presence: { message: "Especifique otra ocupación" } 
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "Email es invalido" },
                     unless: Proc.new { |f| f.email.blank? }

  def get_seqno
    self.seq_no.to_i
  end

  def get_last_name
    lastname = self.last_name1 + ' ' + self.last_name2 unless self.last_name2.blank?
  end

  def requires_occupation?
    occupation == 'Otro'
  end
  
  protected
  def clear_other_occupation
    self.occupation_other = nil if occupation != 'Otro'
  end

end
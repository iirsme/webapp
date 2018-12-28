class Candidate < ApplicationRecord
  attr_accessor :current_user # For Audit purposes

  before_save :clear_other_occupation
  after_create :insert_log
  before_update :update_log
  before_destroy :delete_log

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :curp, presence: { message: "CURP no puede ir vacio" }
  validates :name, presence: { message: "Nombre no puede ir vacio" }
  validates :last_name1, presence: { message: "Al menos un Apellido debe de registrarse" }
  validates :occupation_other, if: :requires_occupation?, presence: { message: "Especifique otra ocupación" } 
  validates :email, format: { with: VALID_EMAIL_REGEX, message: "Email es invalido" },
                     unless: Proc.new { |f| f.email.blank? }


  def insert_log
    puts "****** INSERT AUDIT..."
    Audit.track_change(self.id, self.class.name.downcase, 'I', current_user.id, '{}')
  end

  def delete_log
    puts "****** DELETE AUDIT..."
    Audit.track_change(self.id, self.class.name.downcase, 'D', current_user.id, '{}')
  end  

  def update_log
    puts "****** UPDATE AUDIT..."
    Candidate.columns.each do |columns|
      att = columns.name
      if self.attribute_changed?(att)
        puts "*** #{att}"
        puts "** OLD VALUE: #{self.attribute_was(att)}"
        puts "** NEW VALUE: #{self[att]}"
      end
    end
    Audit.track_change(self.id, self.class.name.downcase, 'U', current_user.id, '{}')
  end

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
    puts "****** Ejecutando cambio de ocupacion..."
    self.occupation_other = nil if occupation != 'Otro'
  end

end
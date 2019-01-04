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
    log = []
    Audit.track_change(self.id, self.class.name.downcase, 'I', current_user.id, log.to_json)
  end

  def delete_log
    log = []
    Audit.track_change(self.id, self.class.name.downcase, 'D', current_user.id, log.to_json)
  end

  def update_log
    log = []
    Candidate.columns.each do |c|
      att = c.name
      if self.attribute_changed?(att) && att != 'updated_at'
        if Geoname.include?(att)
          old_value = Geoname.get_name(self.attribute_was(att))
          new_value = Geoname.get_name(self[att])
        else
          old_value = self.attribute_was(att)
          new_value = self[att]          
        end
        log << { :column => att, :old_value => old_value, :new_value => new_value }
      end
    end
    # Audit.track_change(self.id, self.class.name.downcase, 'U', current_user.id, log.to_json)
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
    self.occupation_other = nil if occupation != 'Otro'
  end

end
class Research < ApplicationRecord
  belongs_to :owner, :class_name => 'User'

  validates :name, presence: { message: "Nombre no puede ir vacio" }
  validates :code, presence: { message: "Codigo no puede ir vacio" }, 
                   uniqueness: { case_sensitive: false, message: "Ya hay otro protocolo con el mismo codigo" }
  validates :password, if: :requires_password?, presence: { message: "Especifique una contraseña para el protocolo" }

  before_save do
    if !password.blank? && is_private
      self.password = Digest::SHA2.hexdigest(get_salt + password)
    elsif !password.blank? && !is_private
      self.password = nil
    end
  end
  
  def requires_password?
    is_private == true
  end
  
  def correct_password?(passw)
    password == Digest::SHA2.hexdigest(get_salt + passw)
  end

  def get_seqno
    self.seq_no.to_i
  end

  # TODO
  def authorized_user?(user)
    true
  end

  # TODO
  def owner?(user)
    user.username == "carlos.reyes"
  end

  def get_salt
    salt = "@_=11r2m3=_@"
  end

end
class Research < ApplicationRecord
  TEMP_PASSWORD = 'TEMP_PASSWORD'
  belongs_to :owner, :class_name => 'User'
  has_many :research_users
  has_many :users, through: :research_users
  has_many :tabs
  has_many :research_fields
  has_many :fields, through: :research_fields
  has_many :patients
  has_many :appointments

  validates :owner, presence: true # See es.yml for error message
  validates :name, presence: { message: "Nombre no puede ir vacio" }
  validates :code, presence: { message: "Codigo no puede ir vacio" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otro protocolo con el mismo Codigo" }
  validates :password, if: :requires_password?, presence: { message: "Especifique una contraseña para el protocolo" }

  before_create :add_owner
  before_update :update_owner
  before_save :set_password
  
  def form_password
    password.present? ? TEMP_PASSWORD : ''
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

  def owner?(research, user)
    research.owner == user
  end

  def get_salt
    salt = "@_=11r2m3=_@"
  end

  def get_default_role
    role = Role.get_default_role
    if role.blank?
      errors.add(:base, "Error de configuración: No se encontró un Rol de Administrador predeterminado.")
      throw(:abort)
    end
    return role
  end

  def get_fields
    research_fields.all.order(seq_no: :asc)
  end

  def get_fields_as_array
    fields = []
    get_fields.each do |rf|
      fields.push(rf.field.id)
    end
    return fields
  end

  private
    def set_password
      if password_changed? && is_private && !password.blank?
        self.password = Digest::SHA2.hexdigest(get_salt + password)
      elsif !is_private && !password.blank?
        self.password = nil
      end
    end

    def add_owner
      if !self.owner.blank?
        ru = ResearchUser.new_record(self.owner, self, get_default_role, true)
        self.research_users << ru
      end
    end

    def update_owner
      if self.attribute_changed?("owner_id")
        ResearchUser.delete_record(self)
        ru = ResearchUser.get_record(self.owner, self)
        if ru.blank?
          add_owner
        else
          ResearchUser.update_role(ru, get_default_role, true)
        end
      end
    end

end
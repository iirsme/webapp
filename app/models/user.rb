class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  has_many :research_users
  has_many :researches, through: :research_users

  validates :username, presence: { message: "Usuario no puede ir vacio" }, 
                       uniqueness: { case_sensitive: false, message: "Ya hay otro usuario con el mismo username" }
  validates :email, presence: { message: "Email no puede ir vacio"}, 
                    uniqueness: { case_sensitive: false, message: "Ya hay otro usuario con el mismo email" }, 
                    format: { with: VALID_EMAIL_REGEX, message: "El email introducido no es valido" }
  validates :firstname, presence: { message: "Nombre no puede ir vacio" }
  validates :lastname, presence: { message: "Apellidos no puede ir vacio" }
  validates :password_digest, presence: { message: "Contraseña no puede ir vacia" }

  def say_hello
    return "Hola #{firstname}".strip if (firstname)
    "Hola Desconocido"
  end

  def full_name
    return "#{firstname}".strip + " " + "#{lastname}".strip
  end

  def exclude_system_admin(users)
    users.reject { |user| user.username == "system.admin" && self.id != user.id }
  end

  def self.all_users
    users = self.all.order(firstname: :asc)
    users.reject { |user| user.username == "system.admin" }
  end

  def admin?
    self.is_admin
  end

  def owner?(research)
    research.owner.id === self.id
  end

  def get_privileges(research)
    role = get_role(research)
    p = {
      :can_create => self.can_create(role),
      :can_read => self.can_read(role),
      :can_update => self.can_update(role),
      :can_audit =>  self.can_audit(role),
      :can_delete => self.can_delete(role)
    }
    puts p
    return p
  end

  def can_create(role)
    return role.nil? ? false : role.can_create
  end

  def can_read(role)
    return role.nil? ? false : role.can_read
  end

  def can_update(role)
    return role.nil? ? false : role.can_update
  end

  def can_delete(role)
    return role.nil? ? false : role.can_delete
  end

  def can_audit(role)
    return role.nil? ? false : role.can_audit
  end

  def get_role(research)
    ru = self.research_users.where(research_id: research.id).first
    if !ru.blank?
      return ru.role
    end
    return nil
  end

end
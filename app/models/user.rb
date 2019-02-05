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

end
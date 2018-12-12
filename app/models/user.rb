class User < ApplicationRecord
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :password_digest, presence: true

  def say_hello
    return "Hola #{firstname}".strip if (firstname)
    "Hola Desconocido"
  end
  
  def exclude_system_admin(users)
    users.reject { |user| user.username == "system.admin" && self.id != user.id }
  end

end
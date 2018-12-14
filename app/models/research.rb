class Research < ApplicationRecord

  validates :name, presence: true
  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, if: -> { is_private == true }

  before_save do
    if !password.blank?
      self.password = Digest::SHA2.hexdigest(get_salt + password)
    end
  end

  def password_correct?(passw)
    password == Digest::SHA2.hexdigest(get_salt + passw)
  end

  def get_salt
    salt = "@_=11r2m3=_@"
  end

end
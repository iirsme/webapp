class Research < ApplicationRecord

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
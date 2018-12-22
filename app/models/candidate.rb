class Candidate < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :curp, presence: true
  validates :name, presence: true
  validates :last_name1, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX,
                              message: "Email invalido" },
                     unless: Proc.new { |f| f.email.blank? }

  def get_seqno
    self.seq_no.to_i
  end
  
  def get_last_name
    lastname = self.last_name1 + ' ' + self.last_name2 unless self.last_name2.blank?
  end

end
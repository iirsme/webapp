class Role < ApplicationRecord
  has_many :research_users
  has_many :users, through: :research_users
  validates :name, presence: { message: "Nombre no puede ir vacio" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otro rol con el mismo nombre" }

  def self.get_default_role
    where(is_default: true).first
  end

  def self.all_roles
    roles = self.all.order(name: :asc)
  end

end
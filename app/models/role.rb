class Role < ApplicationRecord
  has_many :research_users
  has_many :users, through: :research_users
  validates :name, presence: { message: "Nombre no puede ir vacio" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otro rol con el mismo nombre" }

end
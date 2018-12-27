class Role < ApplicationRecord
  validates :name, presence: { message: "Nombre no puede ir vacio" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otro rol con el mismo nombre" }

end
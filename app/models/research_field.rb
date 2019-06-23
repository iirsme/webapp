class ResearchField < ApplicationRecord
  belongs_to :research
  belongs_to :tab, optional: true
  belongs_to :field, optional: true

#  validates :field, uniqueness: { scope: :research,
#                                     message: "Campo duplicado en el Protocolo" }

end
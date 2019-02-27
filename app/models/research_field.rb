class ResearchField < ApplicationRecord
  belongs_to :research
  belongs_to :tab
  belongs_to :field

end
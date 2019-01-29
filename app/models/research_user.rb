class ResearchUser < ApplicationRecord
  belongs_to :user
  belongs_to :research
  belongs_to :role
end
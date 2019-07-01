class ResearchField < ApplicationRecord
  belongs_to :research
  belongs_to :tab, optional: true
  belongs_to :field, optional: true

#  validates :field, uniqueness: { scope: :research,
#                                     message: "Campo duplicado en el Protocolo" }

  def self.get_available_labels(research_id)
    # self.where(research_id: research_id).order(subtitle_label: :asc)
    self.where("research_id = ? AND tab_id IS NULL", research_id).order(subtitle_label: :asc)
  end

end
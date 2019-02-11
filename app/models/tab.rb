class Tab < ApplicationRecord
  belongs_to :research
  
  def self.all_research_tabs(research_id)
    tabs = self.where(research: research_id).order(seq_no: :asc)
  end

end
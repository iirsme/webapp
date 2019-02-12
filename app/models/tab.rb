class Tab < ApplicationRecord
  belongs_to :research

  validates :name, uniqueness: { scope: :research, 
                                 message: "Este nombre de solapa ya esta en uso en el Protocolo" }
  
  def self.get_next_seqno(research_id)
    Tab.all_research_tabs(research_id).count + 1
  end
  
  def self.all_research_tabs(research_id)
    tabs = self.where(research: research_id).order(seq_no: :asc)
  end

end
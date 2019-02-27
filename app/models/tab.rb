class Tab < ApplicationRecord
  belongs_to :research
  has_many :research_fields
  has_many :fields, through: :research_fields

  validates :name, uniqueness: { scope: :research, 
                                 message: "Este nombre de solapa ya esta en uso en el Protocolo" }

  def get_fields
    research_fields.all.order(seq_no: :asc)
  end

  def self.get_next_seqno(research_id)
    Tab.all_research_tabs(research_id).count + 1
  end

  def self.all_research_tabs(research_id)
    tabs = self.where(research: research_id).order(seq_no: :asc)
  end

end
class ResearchField < ApplicationRecord
  belongs_to :research
  belongs_to :tab, optional: true
  belongs_to :field, optional: true

  def self.get_available_labels(research_id)
    self.where("research_id = ? AND tab_id IS NULL", research_id).order(subtitle_label: :asc)
  end

  def self.get_research_columns(research)
    data = {}
    labels = []
    cols = []

    fields = ResearchField.includes(:field, :tab)
    .where("research_fields.research_id = ? AND field_id IS NOT NULL", research)
    .order("tabs.seq_no, research_fields.seq_no")

    fields.each do |f|
      labels.push(f.field.label)
      cols.push(f.field.name)
    end

    data['cols'] = cols
    data['labels'] = labels

    return data
  end

end
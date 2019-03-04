class Field < ApplicationRecord
  has_many :research_fields
  has_many :researches, through: :research_fields

  def full_label
    full_label = "#{label}".strip
    if !unit_of_measure.blank?
      full_label += " " + "(#{unit_of_measure})".strip
    end 
    return full_label
  end

  def self.get_available_fields(research_id)
    research = Research.where(id: research_id).first
    fields = research.get_fields_as_array
    self.where.not(id: fields).order(label: :asc)
  end

  def field_type_name
    field = Field.fields_map.select {|t| t[:id] == field_type}
    name = field[0][:value] unless field.blank?
  end

  def self.fields_map
    [
      {'id': 'text_field', 'value': 'Texto'},
      {'id': 'text_area', 'value': 'Area de Texto'},
      {'id': 'check_box', 'value': 'Si/No'},
      {'id': 'select', 'value': 'Selector'}
    ]
  end

  def self.validations_map
    [
      {'id': 'alpha', 'value': 'Alfabético'},
      {'id': 'numeric', 'value': 'Numérico'},
      {'id': 'alphanumeric', 'value': 'Alfanumérico'}
    ]
  end

end
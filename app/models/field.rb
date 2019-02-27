class Field < ApplicationRecord
  has_many :research_fields
  has_many :researches, through: :research_fields

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
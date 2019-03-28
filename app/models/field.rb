class Field < ApplicationRecord
  has_many :research_fields
  has_many :researches, through: :research_fields

  before_save :evaluate_fields

  validates :name, presence: { message: "Nombre Interno no puede ir vacio" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otra variable con el mismo Nombre Interno" }
  validates :label, presence: { message: "Etiqueta no puede ir vacia" },
                   uniqueness: { case_sensitive: false, message: "Ya hay otra variable con la misma Etiqueta" }
  validates :field_type, presence: { message: "El Tipo de Variable no puede ir vacio" }
  validates :validation_type, if: :requires_validation_type?, presence: { message: "Especifique un tipo de validación para la variable" }

  def requires_validation_type?
    field_type == 'text_field'
  end

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

  protected
  def evaluate_fields
    self.validation_type = nil if field_type != 'text_field'
    self.values = nil if field_type != 'select'

    if field_type == 'select' && !values.blank?
      puts "*****************************************"
      puts values

      ids = []
      vals = []

      options = JSON.parse(values)
      options.each do |opt|
        analize(opt["id"], ids, true)
        analize(opt["value"], vals, false)
      end


    end
  end

  def analize(value, array, regex)
    error = false
    
    error = true if value.blank?
    # continuar
    
    if error
      puts value
      errors.add(:field, "Las opciones deben de ser obligatorias, con ID unicos, solo minusculas y '_' (guion bajo) son permitidos. ")
      throw :abort
    end
  end

end
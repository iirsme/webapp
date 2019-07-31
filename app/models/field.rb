class Field < ApplicationRecord
  TEXT_FIELDS = ['text_field', 'text_area']
  has_many :research_fields
  has_many :researches, through: :research_fields

  before_save :evaluate_name, :evaluate_type

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
  
  def find_by_research_and_name(research_id, name)
    Field
      .select('fields.id, fields.field_type')
      .joins(:research_fields)
      .where('research_id=? AND fields.name=?', research_id, name).first
  end

  def find_by_name(name)
    where(name: name).first
  end

  def get_value(id)
    key = self.values.json.select {|map| map[:id] == id}
    value = key.empty? ? "" : key[0].value
  end

  def get_values(ids)
    result = ""
    return result unless !ids.nil?
    return result unless ids.length > 0

    no_values = ids.length
    ids.each_with_index do |id, idx|
      if !id.empty?
        result = result + "" + self.get_value(id)
        if idx < no_values - 1
          result = result + ", "
        end
      end
    end
    return result
  end

  def self.fields_map
    [
      {'id': 'text_field', 'value': 'Texto'},
      {'id': 'text_area', 'value': 'Area de Texto'},
      {'id': 'check_box', 'value': 'Si/No'},
      {'id': 'select', 'value': 'Selector'},
      {'id': 'multi_select', 'value': 'Selector Multiple'}
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
  def evaluate_name
    if name =~ /^([a-z]+[_]?[a-z]+)+$/
      # do nothing
    else
      errors.add(:field, "Nombre Interno solo minusculas y '_' (guion bajo) son permitidos. ")
      throw :abort
    end
  end

  def evaluate_type
    self.validation_type = nil if field_type != 'text_field'
    self.values = nil unless (field_type == 'select' || field_type == 'multi_select')

    if (field_type == 'select' || field_type == 'multi_select') && !values.blank?
      puts "*****************************************"
      puts values
      puts "*****************************************"
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
    puts "*** Checking: #{value}"
    begin
      raise 'Mandatory Error' if value.blank?
      raise 'Unique Error' if array.include?(value)
      if regex
        if value =~ /^([a-z]+[_]?[a-z]+)+$/ || value =~ /^[0-9]{1,3}$/
          # do nothing
        else
          raise 'Regex Error'
        end
      end
    rescue StandardError => e
      error = true
      puts e.message
    end

    if error
      errors.add(:field, "Las opciones del campo deben de 
      ser obligatorias,
      con ID y Etiquetas unicos,
      solo minusculas y '_' (guion bajo) ó solo numeros (maximo 3 digitos) son permitidos. ")
      throw :abort
    end
    array.push(value)
  end

end
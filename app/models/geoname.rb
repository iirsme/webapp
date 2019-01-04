class Geoname < ApplicationRecord
  ATTRIBUTES = ['birth_city', 'birth_state', 'birth_country', 'address_city', 'address_state', 'address_country'] 

  def self.include?(attribute)
    ATTRIBUTES.include?(attribute)
  end

  def self.find_by_id(id)
    puts "*** Buscando id: #{id}"
    # where(geoname_id: id).first
  end

  def self.get_name(id)
    geoname = find_by_id(id)
    if !geoname
      puts "*** NO encontrado"
      geoname = add(id, name)
    end
  end

  def self.add(id, name)
    puts "*** Creando Geoname #{id} - #{name}"
    # create(geoname_id: id, name: name)
  end
  
end
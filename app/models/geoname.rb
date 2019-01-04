class Geoname < ApplicationRecord
  ATTRIBUTES = ['birth_city', 'birth_state', 'birth_country', 'address_city', 'address_state', 'address_country'] 

  def self.include?(attribute)
    ATTRIBUTES.include?(attribute)
  end

  def self.find_by_id(id)
    where(geoname_id: id).first 
  end

  def self.add(id, name)
    geoname = find_by_id(id)
    create(geoname_id: id, name: name) unless geoname
  end

  def self.get_name(id)
    geoname = find_by_id(id)
    return geoname.name
  end

end
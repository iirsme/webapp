require 'rexml/document'

class Geoname < ApplicationRecord
  ATTRIBUTES = ['birth_city', 'birth_state', 'birth_country', 'address_city', 'address_state', 'address_country'] 

  def self.include?(attribute)
    ATTRIBUTES.include?(attribute)
  end

  def self.find_by_id(id)
    where(geoname_id: id).first
  end

  def self.get_name(id)
    return nil if id.blank?
    geoname = find_by_id(id)
    if !geoname
      name = go_to_webservice(id)
      geoname = add(id, name) unless name.blank?
    else
    end
    return geoname.name unless geoname.blank?
    nil
  end

  def self.add(id, name)
    begin
      create(geoname_id: id, name: name)
    rescue Exception => e
      puts "ERROR while adding new Geoname"
      puts e.message
      puts e.backtrace
      return nil
    end
  end

  def self.go_to_webservice(id)
    response = HTTParty.get("http://api.geonames.org/get?geonameId=#{id}&lang=es&username=sanjish")
    if response
      xml = REXML::Document.new response.body
      if xml
        puts "*******************************"
        puts xml.to_s
        puts "*******************************"
        return xml.root.elements['name'].text()
      end
    end
    nil
  end

end
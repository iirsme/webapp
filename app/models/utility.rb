class Utility
  
  def self.translate_value(value)
    val = value
    if val.class == Array
      aux_val = ""
      val.each do |e|
        if !e.empty?
          aux_val+= "#{e}, "
        end
      end
      val = aux_val
      if val.end_with?(", ")
        val.delete_suffix!(", ")
      end
    end
    return val
  end
  
end
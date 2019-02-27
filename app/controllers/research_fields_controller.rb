class ResearchFieldsController < ApplicationController

  def add_fields
    puts "***** #{params}"
    idx = ""
    fields = []
    params.each do |key, value|
      if key.start_with?("tab_field_idx_")
        idx = value
      elsif key.start_with?("field_")
        fields.push(value);
      end
    end
    tab_id = params["tab_field_id_#{idx}"]
    research_id = params["tab_field_research_#{idx}"]

  end

end
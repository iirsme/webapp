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

    ResearchField.where(tab_id: tab_id).delete_all
    fields.each_with_index { |field, idx|
      ResearchField.create(research_id: research_id, tab_id: tab_id, field_id: field, is_required: false, seq_no: idx)
    }
    
    # TODO: Enhance this code to handle errors and success messages
    @title = "Variables agregadas exitosamente"
    @is_error = false
    respond_to do |format|
      format.js { render partial: 'researches/wizard/messages'}
    end
  end

end
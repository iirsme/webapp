class ResearchFieldsController < ApplicationController

  def add_label
    puts "***** #{params}"

  end

  def get_labels
    puts "***** #{params}"
    research_id = params[:research_id]
    @research = Research.find(params[:research_id])
    labels = Field.get_available_fields(research_id)

  end

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

    subtitles = ResearchField.where("tab_id = ? AND field_id IS NULL", tab_id)
    subtitles.each { |subtitle|
      subtitle.update(tab_id: nil, seq_no: 0)
    }
    
    ResearchField.where("tab_id = ?", tab_id).delete_all
    
    fields.each_with_index { |field, idx|
      f = Field.where(id: field).first
      if f.nil?
        rf = ResearchField.where(id: field).first
        rf.update(tab_id: tab_id, seq_no: idx)
      else
        ResearchField.create(research_id: research_id, tab_id: tab_id, field_id: field, is_required: false, seq_no: idx)
      end
    }
    
    # TODO: Enhance this code to handle errors and success messages
    @title = "Variables agregadas exitosamente"
    @is_error = false
    respond_to do |format|
      format.js { render partial: 'researches/wizard/messages'}
    end
  end

end
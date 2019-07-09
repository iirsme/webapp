class ResearchFieldsController < ApplicationController

  def add_label
    research_id = params[:label_research_id]
    label_name = params[:label_name]
    @research = Research.find(research_id)
    
    if label_name.blank?
      @title = "El nombre es necesario para agregar un nuevo Subtitulo"
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end
    
    @label = ResearchField.new(research_id: research_id, seq_no: 0, subtitle_label: label_name)
    if @label.save
      labels = ResearchField.get_available_labels(research_id)
      @master_data = {:labels => labels}
      @title = "Subtitulo agregado exitosamente"
      @is_error = false
      respond_to do |format|
        format.js { render partial: 'research_tabs/refresh_research_labels'}
      end
      return
    else
      @title = @label.errors.messages[:name][0]
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end
  end
  
  def delete_label
    research_id = params[:research_id]
    @research = Research.find(research_id)
    label_id = params[:label_id]
    label = ResearchField.where(id: label_id).first
    label.destroy

    labels = ResearchField.get_available_labels(research_id)
    @master_data = {:labels => labels}
    @title = "Subtitulo eliminado exitosamente"
    @is_error = false
    respond_to do |format|
      format.js { render partial: 'research_tabs/refresh_research_labels'}
    end
  end

  def add_fields
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
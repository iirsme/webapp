class TabsController < ApplicationController

  def get_research_tabs
    research_id = params[:research_id]
    @research = Research.find(params[:research_id])
    @research.id? # Raise intentionally an error if nil
    tabs = Tab.all_research_tabs(research_id)
    fields = Field.get_available_fields(research_id)
    labels = ResearchField.get_available_labels(research_id)
    @master_data = {:tabs => tabs, :fields => fields, :labels => labels}

    respond_to do |format|
      format.js { render partial: 'research_tabs/get_research_tabs'}
    end
  end

  def add_research_tab
    research_id = params["t_research_id"]
    @research = Research.find(research_id)
    name = params[:name]

    if name.blank?
      @title = "El nombre es necesario para agregar una nueva Solapa"
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end

    @tab = Tab.new(name: name, research_id: research_id, seq_no: Tab.get_next_seqno(research_id))
    if @tab.save
      tabs = Tab.all_research_tabs(research_id)
      fields = Field.get_available_fields(research_id)
      labels = ResearchField.get_available_labels(research_id)
      @master_data = {:tabs => tabs, :fields => fields, :labels => labels}
      @title = "Solapa creada exitosamente"
      @is_error = false
      respond_to do |format|
        format.js { render partial: 'research_tabs/refresh_research_tabs'}
      end
      return
    else
      @title = @tab.errors.messages[:name][0]
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return 
    end
  end

  def update_research_tab
    idx = ""
    seq_modified = false
    params.each do |key, value|
      if key.start_with?("tab_idx_")
        idx = value
      end
    end
    tab_id = params["tab_id_#{idx}"]
    name = params["tab_name_#{idx}"]
    seq = params["tab_seq_#{idx}"]
    research_id = params["tab_research_#{idx}"]
    @research = Research.find(research_id)

    @tab = Tab.where(id: tab_id).first
    if !name.blank?
      @tab.name = name
    end
    if !seq.blank? && is_number?(seq)
      seq = seq.to_i
      tabs_num = Tab.all_research_tabs(research_id).count
      if seq > 0 && seq <= tabs_num
        seq_modified = true
        @tab.seq_no = seq
      else
        @title = "La nueva posición debe de estar entre 1 y #{tabs_num}"
        @is_error = true
        respond_to do |format|
          format.js { render partial: 'researches/wizard/messages'}
        end
        return
      end
    end

    if @tab.save
      if seq_modified
        research_tabs = Tab.where("id <> ? AND research_id = ?", tab_id, research_id).order(seq_no: :asc)
        new_seq = 1
        research_tabs.each do |t|
          if new_seq != seq
            t.seq_no = new_seq
          elsif new_seq == seq
            new_seq = new_seq + 1
            t.seq_no = new_seq
          end
          t.save
          new_seq = new_seq + 1
        end
      end
      tabs = Tab.all_research_tabs(research_id)
      fields = Field.get_available_fields(research_id)
      labels = ResearchField.get_available_labels(research_id)
      @master_data = {:tabs => tabs, :fields => fields, :labels => labels}
      respond_to do |format|
        format.js { render partial: 'research_tabs/refresh_research_tabs'}
      end
    else
      @title = @tab.errors.messages[:name][0]
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return 
    end
  end

  def delete_research_tab
    research_id = params[:research_id]
    @research = Research.find(research_id)
    tab_id = params[:tab_id]
    tab = Tab.where(id: tab_id).first
    tab.destroy
    
    tabs = Tab.all_research_tabs(research_id)
    fields = Field.get_available_fields(research_id)
    labels = ResearchField.get_available_labels(research_id)
    @master_data = {:tabs => tabs, :fields => fields, :labels => labels}
    @title = "Solapa eliminada exitosamente"
    @is_error = false
    respond_to do |format|
      format.js { render partial: 'research_tabs/refresh_research_tabs'}
    end
  end

end
class TabsController < ApplicationController

  def get_research_tabs
    research_id = params[:research_id]
    tabs = Tab.all_research_tabs(research_id)
    fields = Field.all
    @master_data = {:tabs => tabs, :fields => fields}
    respond_to do |format|
      format.js { render partial: 'research_tabs/get_research_tabs'}
    end
  end

  def add_research_tab
    research_id = params["t_research_id"]
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
      fields = Field.all
      @master_data = {:tabs => tabs, :fields => fields}
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
    params.each do |key, value|
      if key.start_with?("tab_idx_")
        idx = value
      end
    end
    tab_id = params["tab_id_#{idx}"]
    name = params["tab_name_#{idx}"]
    research_id = params["tab_research_#{idx}"]

    if name.blank?
      @title = "El nombre de una Solapa es obligatorio"
      @is_error = true
      respond_to do |format|
        format.js { render partial: 'researches/wizard/messages'}
      end
      return
    end

    @tab = Tab.where(id: tab_id).first
    @tab.name = name
    if @tab.save
      tabs = Tab.all_research_tabs(research_id)
      fields = Field.all
      @master_data = {:tabs => tabs, :fields => fields}
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
    tab_id = params[:tab_id]
    tab = Tab.where(id: tab_id).first
    tab.destroy
    
    tabs = Tab.all_research_tabs(research_id)
    fields = Field.all
    @master_data = {:tabs => tabs, :fields => fields}
    respond_to do |format|
      format.js { render partial: 'research_tabs/refresh_research_tabs'}
    end
  end

  def add_fields
    puts "***** #{params}"
  end

end
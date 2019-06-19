class RemoveIndexFromResearchFields < ActiveRecord::Migration[5.2]
  def change
    remove_index "research_fields", name: "index_research_fields_on_research_id_and_field_id"
  end
end

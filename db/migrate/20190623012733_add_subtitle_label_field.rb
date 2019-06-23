class AddSubtitleLabelField < ActiveRecord::Migration[5.2]
  def change
    add_column :research_fields, :subtitle_label, :string
    change_column :research_fields, :tab_id, :uuid, :null => true
  end
end

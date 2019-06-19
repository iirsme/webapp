class RemoveNotNullConstraintToFields < ActiveRecord::Migration[5.2]
  def change
    change_column :research_fields, :field_id, :uuid, :null => true
  end
end

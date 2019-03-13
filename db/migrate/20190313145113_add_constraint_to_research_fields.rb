class AddConstraintToResearchFields < ActiveRecord::Migration[5.2]
  def change
    add_index :research_fields, [:research_id, :field_id], unique: true
  end
end

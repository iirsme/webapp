class AddConstraintToTabs < ActiveRecord::Migration[5.2]
  def change
    add_index :tabs, [:name, :research_id], unique: true
  end
end

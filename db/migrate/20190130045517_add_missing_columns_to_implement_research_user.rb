class AddMissingColumnsToImplementResearchUser < ActiveRecord::Migration[5.2]
  def change
    add_column :research_users, :is_owner, :boolean, null: false, default: false
    add_column :roles, :is_default, :boolean, null: false, default: false
  end
end

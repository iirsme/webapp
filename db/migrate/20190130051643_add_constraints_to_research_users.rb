class AddConstraintsToResearchUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :research_users, [:user_id, :research_id], unique: true
  end
end

class AddConstraintToPatients < ActiveRecord::Migration[5.2]
  def change
    add_index :patients, [:research_id, :candidate_id], unique: true
  end
end

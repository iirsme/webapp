class AddAniosDeResidenciaFieldToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :years_of_residence, :integer
  end
end

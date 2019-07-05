class AddObesityFieldToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :obesity, :json
  end
end

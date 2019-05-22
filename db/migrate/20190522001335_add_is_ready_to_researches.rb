class AddIsReadyToResearches < ActiveRecord::Migration[5.2]
  def change
    add_column :researches, :is_ready, :boolean, default: false
  end
end

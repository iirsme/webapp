class AddOwnerToResearches < ActiveRecord::Migration[5.2]
  def change
    add_reference :researches, :owner, type: :uuid, index: true, foreign_key: { to_table: :users }
  end
end

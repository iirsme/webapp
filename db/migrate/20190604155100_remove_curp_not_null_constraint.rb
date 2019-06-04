class RemoveCurpNotNullConstraint < ActiveRecord::Migration[5.2]
  def change
    change_column :candidates, :curp, :string, :null => true
  end
end

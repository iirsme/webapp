class AddUnitToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :unit_of_measure, :string
  end
end

class AddMissingColumnsToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :validation_type, :string
    add_column :fields, :description, :text
  end
end

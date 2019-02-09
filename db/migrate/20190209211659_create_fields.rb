class CreateFields < ActiveRecord::Migration[5.2]
  def change
    create_table :fields, id: :uuid do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.string :field_type, null: false
      t.jsonb :values
      t.timestamps
    end
  end
end

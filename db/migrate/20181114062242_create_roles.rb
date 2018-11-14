class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles, id: :uuid do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :can_create, null: false, default: false
      t.boolean :can_read, null: false, default: true
      t.boolean :can_update, null: false, default: false
      t.boolean :can_delete, null: false, default: false
      t.timestamps
    end
  end
end

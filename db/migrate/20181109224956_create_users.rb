class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.string :password_digest, null: false
      t.boolean :is_admin, null: false, default: false
      t.timestamps
    end
  end
end

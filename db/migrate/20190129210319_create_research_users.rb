class CreateResearchUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :research_users, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, index: true, foreign_key: true
      t.references :research, type: :uuid, null: false, index: true, foreign_key: true
      t.references :role, type: :uuid, null: false, index: true, foreign_key: true
    end
  end
end

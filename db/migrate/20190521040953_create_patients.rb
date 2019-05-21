class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients, id: :uuid do |t|
      t.references :research, type: :uuid, null: false, index: true, foreign_key: true
      t.references :candidate, type: :uuid, null: false, index: true, foreign_key: true
    end
  end
end

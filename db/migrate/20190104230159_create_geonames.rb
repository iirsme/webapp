class CreateGeonames < ActiveRecord::Migration[5.2]
  def change
    create_table :geonames, id: :uuid do |t|
      t.string :geoname_id, foreign_key: false, index: true, null: false
      t.string :name, null: false
    end
  end
end
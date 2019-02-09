class CreateTabs < ActiveRecord::Migration[5.2]
  def change
    create_table :tabs, id: :uuid do |t|
      t.string :name, null: false
      t.references :research, foreign_key: true, type: :uuid, index: true, null: false
      t.numeric :seq_no
    end
  end
end

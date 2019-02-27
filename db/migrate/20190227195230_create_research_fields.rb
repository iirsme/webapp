class CreateResearchFields < ActiveRecord::Migration[5.2]
  def change
    create_table :research_fields, id: :uuid do |t|
      t.references :research, type: :uuid, null: false, index: true, foreign_key: true
      t.references :tab, type: :uuid, null: false, index: true, foreign_key: true
      t.references :field, type: :uuid, null: false, index: true, foreign_key: true
      t.boolean :is_required, null: false, default: false
      t.numeric :seq_no, null: false
    end
  end
end

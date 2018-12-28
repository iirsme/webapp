class CreateAudits < ActiveRecord::Migration[5.2]
  def change
    create_table :audits, id: :uuid do |t|
      t.uuid :record_id, foreign_key: false, index: true, null: false
      t.string :entity, null: false
      t.string :action, null: false
      t.references :user, foreign_key: true, type: :uuid, index: true, null: false
      t.datetime :done_at, null: false
      t.jsonb :log, null: false, default: '{}'
    end
  end
end

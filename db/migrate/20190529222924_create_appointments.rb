class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments, id: :uuid do |t|
      t.references :research, type: :uuid, null: false, index: true, foreign_key: true
      t.references :patient, type: :uuid, null: false, index: true, foreign_key: true
      t.numeric :appt_no
      t.date :appt_date, null: false
      t.time :appt_time, null: false
      t.string :status, null: false
      t.text :notes
      t.jsonb :values
      t.timestamps
    end
  end
end

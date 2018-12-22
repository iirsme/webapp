class CreateCandidates < ActiveRecord::Migration[5.2]
  def change
    create_table :candidates, id: :uuid do |t|
      t.numeric :seq_no
      t.string :curp, null: false
      t.string :name, null: false
      t.string :last_name1, null: false
      t.string :last_name2
      t.date :birth_date
      t.date :evaluation_date
      t.integer :age
      t.string :phone
      t.string :cell_phone
      t.string :email
      t.string :gender
      t.string :marital_status
      t.string :occupation
      t.string :occupation_other
      t.string :scolarship
      t.string :birth_city
      t.string :birth_state
      t.string :birth_country
      t.string :address_main_street
      t.string :address_street_no1
      t.string :address_street_no2
      t.string :address_street1
      t.string :address_street2
      t.string :address_region
      t.string :address_city
      t.string :address_state
      t.string :address_country
      t.string :diagnosis
      t.date :diagnosis_date
      t.timestamps
    end
    
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE candidates ALTER COLUMN seq_no SET DEFAULT nextval('candidate_seq');
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE candidates ALTER COLUMN seq_no SET NOT NULL;
        SQL
      end
    end
  end
end

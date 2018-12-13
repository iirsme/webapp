class CreateResearches < ActiveRecord::Migration[5.2]
  def change
    create_table :researches, id: :uuid do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.boolean :is_private, default: false
      t.string :password
      t.numeric :seq_no
    end
    
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE researches ALTER COLUMN seq_no SET DEFAULT nextval('research_seq');
        SQL
      end

      dir.down do
        execute <<-SQL
          ALTER TABLE researches ALTER COLUMN seq_no SET NOT NULL;
        SQL
      end
    end
  end
end

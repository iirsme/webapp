class CreateCandidateSequence < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE SEQUENCE candidate_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE candidate_seq;
    SQL
  end
end

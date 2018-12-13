class CreateResearchSequence < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE SEQUENCE research_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE research_seq;
    SQL
  end
end
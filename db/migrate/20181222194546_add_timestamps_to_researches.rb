class AddTimestampsToResearches < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:researches)
  end
end

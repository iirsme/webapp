class AddTimestampsToPatients < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:patients)
  end
end

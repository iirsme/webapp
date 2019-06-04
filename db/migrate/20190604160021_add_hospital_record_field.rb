class AddHospitalRecordField < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :hospital_record, :string
  end
end
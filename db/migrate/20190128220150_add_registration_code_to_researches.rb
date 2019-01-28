class AddRegistrationCodeToResearches < ActiveRecord::Migration[5.2]
  def change
    add_column :researches, :registration_code, :string
  end
end

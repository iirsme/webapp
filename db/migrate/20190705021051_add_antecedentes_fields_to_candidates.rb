class AddAntecedentesFieldsToCandidates < ActiveRecord::Migration[5.2]
  def change
    add_column :candidates, :dm2, :json
    add_column :candidates, :hta, :json
    add_column :candidates, :ecv, :json
    add_column :candidates, :iam, :json
    add_column :candidates, :irc, :json
    add_column :candidates, :evc, :json
    add_column :candidates, :cancer, :json
    add_column :candidates, :hipercolesterolemia, :json
    add_column :candidates, :ar, :boolean, default: false
    add_column :candidates, :lupus, :boolean, default: false
    add_column :candidates, :espondilitis, :boolean, default: false
    add_column :candidates, :miopatia, :boolean, default: false
    add_column :candidates, :other_illness, :boolean, default: false
    add_column :candidates, :str_illness_other, :string
  end
end

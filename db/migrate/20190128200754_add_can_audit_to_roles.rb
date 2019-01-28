class AddCanAuditToRoles < ActiveRecord::Migration[5.2]
  def change
    add_column :roles, :can_audit, :boolean, default: false
  end
end

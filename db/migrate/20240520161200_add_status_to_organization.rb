class AddStatusToOrganization < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :status, :integer, default: 0
  end
end

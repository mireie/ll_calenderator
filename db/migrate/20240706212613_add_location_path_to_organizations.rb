class AddLocationPathToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :location_path, :string
  end
end

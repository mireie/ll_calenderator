class AddStandingsPathToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :standings_path, :string, default: "/standings"
  end
end

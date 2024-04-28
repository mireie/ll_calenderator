class AddFieldsToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :base_url, :string
    add_column :organizations, :leagues_path, :string
    add_column :organizations, :teams_path, :string
    add_column :organizations, :schedule_path, :string

    add_column :games, :field, :string
  end
end

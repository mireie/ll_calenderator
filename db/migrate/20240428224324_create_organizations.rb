class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :description
      t.string :location_path

      t.timestamps
    end
  end
end

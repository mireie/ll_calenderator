class AddExternalIdToLocations < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :external_id, :string
  end
end

class AddIndexForLatLong < ActiveRecord::Migration[7.0]
  def change
    add_index :locations, [:latitude, :longitude]
  end
end

class AddVerifiedAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :locations, :verified, :boolean, default: false
  end
end

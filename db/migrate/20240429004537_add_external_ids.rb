class AddExternalIds < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :external_id, :string
    add_column :teams, :external_id, :string
    add_column :leagues, :external_id, :string
  end
end

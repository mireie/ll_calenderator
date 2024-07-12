class AddDurationToLeague < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :duration, :integer, default: 60
  end
end

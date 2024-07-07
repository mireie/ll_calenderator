class AddTimeZoneToLeague < ActiveRecord::Migration[7.0]
  def change
    add_column :leagues, :time_zone, :string
  end
end

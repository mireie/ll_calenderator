class AddLeagueEndDate < ActiveRecord::Migration[8.0]
  def change
    add_column :leagues, :end_date, :date
  end
end

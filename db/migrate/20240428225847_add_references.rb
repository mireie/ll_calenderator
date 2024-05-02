class AddReferences < ActiveRecord::Migration[7.0]
  def change
    add_reference :leagues, :organization, null: false, foreign_key: true
    add_reference :teams, :league, foreign_key: true
    add_reference :games, :league, null: false, foreign_key: true
    add_reference :games, :location, foreign_key: true
    add_reference :games, :home_team, null: false, foreign_key: { to_table: :teams }
    add_reference :games, :away_team, null: false, foreign_key: { to_table: :teams }
  end
end

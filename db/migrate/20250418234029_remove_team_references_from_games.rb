class RemoveTeamReferencesFromGames < ActiveRecord::Migration[8.0]
  def change
    remove_reference :games, :home_team, foreign_key: { to_table: :teams }
    remove_reference :games, :away_team, foreign_key: { to_table: :teams }
  end
end

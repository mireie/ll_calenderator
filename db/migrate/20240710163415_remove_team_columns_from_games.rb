class RemoveTeamColumnsFromGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :home_team_id, :bigint
    remove_column :games, :away_team_id, :bigint
    remove_column :games, :home_team_score, :integer
    remove_column :games, :away_team_score, :integer
  end
end

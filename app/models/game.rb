class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'
  has_one :organization, through: :league
  has_one :location

  class << self
    def fetch_and_proccess_games
      # Fetch games from external API

      # Process games
    end
  end
end

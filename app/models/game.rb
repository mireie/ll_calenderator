class Game < ApplicationRecord
  belongs_to :league
  has_one :location

  class << self
    def fetch_and_proccess_games
      # Fetch games from external API

      # Process games
    end
  end
end

class Game < ApplicationRecord
  has_one :location
  belongs_to :league
  belongs_to :organization, through: :league
  has_many :teams
  class << self
    def fetch_and_proccess_games
      # Fetch games from external API

      # Process games
    end
  end
end

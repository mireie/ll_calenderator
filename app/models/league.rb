class League < ApplicationRecord
  has_many :teams
  has_many :games
  belongs_to :organization

  def self.fetch_and_process_leagues
    # Fetch leagues from external website

    # Process leagues

  end
end

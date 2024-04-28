class League < ApplicationRecord
  belongs_to :organization
  has_many :teams
  has_many :games

  def self.fetch_and_process_leagues
    # Fetch leagues from external website

    # Process leagues

  end
end

class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  def self.fetch_and_process_leagues
    # Fetch leagues from external website

    # Process leagues
  end
end

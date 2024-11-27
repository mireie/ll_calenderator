# frozen_string_literal: true

# The Organization model is responsible for the top-level organization that is responsible for the
# leagues, teams, and games
class Organization < ApplicationRecord
  has_many :leagues, dependent: :destroy
  has_many :teams, through: :leagues
  has_many :games, through: :leagues

  enum :status, %i[inactive active]

  scope :active, -> { where(status: :active) }
  default_scope { active }

  DEFAULT_LEAGUES_PATH = "/leagues"
  DEFAULT_TEAMS_PATH = "/teams"
  DEFAULT_SCHEDULE_PATH = "/schedule"
  DEFAULT_LOCATION_PATH = "/locations"

  def leagues_url
    base_url + leagues_path
  end

  def leagues_by_sport
    leagues.group_by(&:sport)
  end
end

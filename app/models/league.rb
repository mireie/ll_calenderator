# frozen_string_literal: true

# The League model represents a league in the system
class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  DEFAULT_TIME_ZONE = "America/Los_Angeles"

  require "icalendar/tzinfo"

  broadcasts_to ->(league) { "leagues" }, inserts_by: :prepend

  scope :active, lambda {
    leagues_with_games = League.includes(:games).where(games: { start_time: Time.zone.now.. }).distinct
    leagues_with_games.presence || League.where(start_date: Time.zone.now..).distinct
  }

  scope :with_future_games, lambda {
    League.includes(:games).where(games: { start_time: Time.zone.now.. }).distinct
  }

  def sync_schedule
    LeagueScheduleSyncJob.perform_async(id)
  end

  # Fly's postgreSQL database does not support array types, so we store the days as a JSON string
  # TODO: Refactor to store as JSON or something
  def days
    day_string = read_attribute(:days)
    return [] if day_string.blank?

    JSON.parse(read_attribute(:days).to_s)
  end

  def url
    "#{organization.base_url}/league/#{external_id}"
  end

  def schedule_url
    url + organization.schedule_path
  end

  def standings_url
    url + organization.standings_path
  end

  def teams_url
    url + organization.teams_path
  end
end

# frozen_string_literal: true

# The League model represents a league in the system
class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  require "icalendar/tzinfo"

  broadcasts_to ->(league) { "leagues" }, inserts_by: :prepend

  scope :active, lambda {
    where(start_date: 3.months.ago..)
  }
  scope :upcoming, -> { where("start_date > ?", Time.zone.now) }

  scope :with_future_games, lambda {
    League.includes(:games).where(games: { start_time: Time.zone.now.. }).distinct
  }

  def sync_details
    attributes = DataServices::LeagueDataService.new.league_attributes(details_url)
    assign_attributes(attributes)
    save! if changed? || new_record?
  end

  def sync_schedule
    DataServices::ScheduleDataService.new.parse(schedule_url)
    DataServices::ScheduleDataService.new.cleanup_removed_games(schedule_url)
  end

  # TODO: Refactor to use jsonb
  def days
    day_string = read_attribute(:days)
    return [] if day_string.blank?

    JSON.parse(read_attribute(:days).to_s)
  end

  def url
    "#{organization.base_url}/league/#{external_id}"
  end

  def details_url
    url + "/details"
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

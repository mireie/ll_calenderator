# frozen_string_literal: true

# The League model represents a league in the system
class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  require "icalendar/tzinfo"

  def sync_schedule
    LeagueScheduleSyncJob.perform_later(id)
  end

  # Fly's postgreSQL database does not support array types, so we store the days as a JSON string
  # TODO: Refactor to store as JSON or something
  def days
    day_string = read_attribute(:days)
    return [] if day_string.blank?

    JSON.parse(read_attribute(:days).to_s)
  end

  def games_to_ical
    cal = Icalendar::Calendar.new
    # TODO: Add timezone support
    tzid = "UTC"
    tz = TZInfo::Timezone.get(tzid)
    timezone = tz.ical_timezone(Time.zone.now)
    cal.add_timezone(timezone)
    games.each { |game| cal.add_event(game.to_ical) }
    cal.to_ical
  end

  def url
    "#{organization.base_url}/league/#{external_id}"
  end
end

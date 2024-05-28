# frozen_string_literal: true

# The League model represents a league in the system
class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  require "icalendar/tzinfo"

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

  def publish_calendar
    FileUtils.mkdir_p("public/organizations/#{organization_id}/#{external_id}")

    File.write("public/organizations/#{organization_id}/#{external_id}/games.ics", games_to_ical)
  end
end

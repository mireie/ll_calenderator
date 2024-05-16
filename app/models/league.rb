class League < ApplicationRecord
  belongs_to :organization
  has_many :teams, dependent: :nullify
  has_many :games, dependent: :destroy

  require "icalendar/tzinfo"

  def publish_calendar
    FileUtils.mkdir_p("public/organizations/#{organization_id}/#{external_id}")

    File.open("public/organizations/#{organization_id}/#{external_id}/games.ics", "w") do |f|
      f.write(games_to_ical)
    end
  end

  private

  def games_to_ical
    cal = Icalendar::Calendar.new
    # TODO: Add timezone support
    tzid = "UTC"
    tz = TZInfo::Timezone.get(tzid)
    timezone = tz.ical_timezone(Time.now)
    cal.add_timezone(timezone)
    games.each { |game| cal.add_event(game.to_ical) }
    cal.to_ical
  end
end

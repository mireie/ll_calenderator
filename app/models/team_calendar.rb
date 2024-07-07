# frozen_string_literal: true

class TeamCalendar
  attr_reader :team, :games

  require "icalendar/tzinfo"

  def initialize(team)
    @team = team
  end

  def to_ical
    cal = Icalendar::Calendar.new

    @team.games.each { |game| cal.add_event(game.to_ical) }
    cal.add_timezone(timezone)
    cal.to_ical
  end

  private

  def timezone
    # TODO: Add timezone support
    tzid = @team.league.time_zone || "UTC"
    tz = TZInfo::Timezone.get(tzid)
    tz.ical_timezone(Time.zone.now)
  end
end

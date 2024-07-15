# frozen_string_literal: true

class TeamCalendar
  attr_reader :team, :games

  def initialize(team)
    @team = team
  end

  def to_ical
    cal = Icalendar::Calendar.new
    cal.add_timezone(timezone.ical_timezone(Time.zone.now))
    @team.games.each do |game|
      event = game[:game].to_ical(game[:role])
      event = event_timezone(event)
      cal.add_event(event)
    end
    cal.to_ical
  end

  private

  def timezone
    tzid = @team.league.time_zone || League::DEFAULT_TIME_ZONE
    TZInfo::Timezone.get(tzid)
  end

  def event_timezone(event)
    event.dtstart = Icalendar::Values::DateTime.new(event.dtstart, "tzid" => timezone.canonical_identifier)
    event.dtend = Icalendar::Values::DateTime.new(event.dtend, "tzid" => timezone.canonical_identifier)
    event
  end
end

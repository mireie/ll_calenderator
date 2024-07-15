# frozen_string_literal: true

class TeamCalendar
  attr_reader :team, :games

  def initialize(team)
    @team = team
  end

  def to_ical
    cal = Icalendar::Calendar.new
    cal.timezone do |t|
      t.tzid = timezone
    end
    @team.games.each do |game|
      event = game[:game].to_ical(game[:role])
      event = event_timezone(event) # Adjust event times to UTC
      cal.add_event(event)
    end
    cal.to_ical
  end

  private

  def timezone
    "UTC"
  end

  def event_timezone(event)
    # Set event start and end times to UTC
    event.dtstart = Icalendar::Values::DateTime.new(event.dtstart.to_time.utc, "tzid" => timezone)
    event.dtend = Icalendar::Values::DateTime.new(event.dtend.to_time.utc, "tzid" => timezone)
    event
  end
end

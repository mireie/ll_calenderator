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
      cal.add_event(game[:game].to_ical(game[:role]))
    end
    cal.to_ical
  end

  private

  def timezone
    tzid = "America/Los_Angeles"
    TZInfo::Timezone.get(tzid)
  end
end

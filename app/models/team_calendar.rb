# frozen_string_literal: true

class TeamCalendar
  attr_reader :team, :games

  require "icalendar/tzinfo"

  def initialize(team)
    @team = team
  end

  def to_ical
    cal = Icalendar::Calendar.new
    @team.games.each do |game|
      cal.add_event(game[:game].to_ical(game[:role]))
    end
    cal.to_ical
  end
end

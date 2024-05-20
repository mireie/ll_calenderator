# frozen_string_literal: true

# The Team model represents a team in the system
class Team < ApplicationRecord
  belongs_to :league
  has_one :organization, through: :league
  has_many :home_games, class_name: "Game", foreign_key: "home_team_id", dependent: :destroy, inverse_of: :home_team
  has_many :away_games, class_name: "Game", foreign_key: "away_team_id", dependent: :destroy, inverse_of: :away_team

  require "icalendar/tzinfo"

  def games
    Game.where("home_team_id = ? OR away_team_id = ?", id, id)
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
end

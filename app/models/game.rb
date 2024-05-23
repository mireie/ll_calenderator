# frozen_string_literal: true

# The Game model represents a game in the system
class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_one :organization, through: :league
  has_one :location, dependent: :nullify

  require "icalendar/tzinfo"

  class << self
    def fetch_and_proccess_games
      # Fetch games from external API

      # Process games
    end
  end

  def to_ical
    # Convert game to ical format
    # https://icalendar.org/RFC-Specifications/iCalendar-RFC-5545/
    tzid = "UTC"
    event = Icalendar::Event.new
    event.dtstart = Icalendar::Values::DateTime.new(start_time.utc, "tzid" => tzid)
    event.dtend = Icalendar::Values::DateTime.new(start_time.utc + 1.hour, "tzid" => tzid)
    event.summary = "#{home_team.name} vs #{away_team.name} at #{field}"

    event
  end
end

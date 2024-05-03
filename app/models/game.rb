class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  has_one :organization, through: :league
  has_one :location

  class << self
    def fetch_and_proccess_games
      # Fetch games from external API

      # Process games
    end
  end

  def to_ical
    # Convert game to ical format
    # https://icalendar.org/RFC-Specifications/iCalendar-RFC-5545/
    event = Icalendar::Event.new
    event.dtstart = start_time
    event.dtend = start_time + 1.hour
    event.summary = "#{home_team.name} vs #{away_team.name} at #{field}"

    event
  end
end

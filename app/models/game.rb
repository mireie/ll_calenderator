# frozen_string_literal: true

# The Game model represents a game in the system
class Game < ApplicationRecord
  belongs_to :league
  belongs_to :home_team, class_name: "Team"
  belongs_to :away_team, class_name: "Team"
  belongs_to :location, optional: true
  has_one :organization, through: :league

  enum status: { scheduled: 0, in_progress: 1, completed: 2, removed: 3 }

  require "icalendar/tzinfo"

  def to_ical
    # Convert game to ical format
    # https://icalendar.org/RFC-Specifications/iCalendar-RFC-5545/
    tzid = "UTC"
    cal = Icalendar::Event.new
    update_event(cal, tzid)
  end

  def description
    return base_description if location&.verified?

    <<~DESC
      #{base_description}

      *Note: This location has not been verified. Please double check the address before heading to the game.
    DESC
  end

  # TODO: This should be extracted to a service object
  # TODO: Add proper duration
  def event_details(tzid)
    {
      uid: "game-#{id}",
      description:,
      dtstamp: formatted_time(updated_at, tzid),
      dtstart: formatted_time(start_time, tzid),
      dtend: formatted_time(start_time + 1.hour, tzid),
      location: location&.address,
      summary:,
    }
  end

  def formatted_time(time, tzid)
    Icalendar::Values::DateTime.new(time.utc, "tzid" => tzid)
  end

  def update_event(cal, tzid)
    event_details(tzid).each do |key, value|
      cal.send("#{key}=", value)
    end
    cal
  end

  def summary
    "#{home_team.name} vs. #{away_team.name} at #{field || 'TBD'}"
  end

  private

  def base_description
    <<~DESC
      #{home_team.name} vs. #{away_team.name}

      #{league.title}
      Field: #{field || 'TBD'} - #{location&.name || 'TBD'}
      Start Time: #{start_time.strftime('%l:%M %p')}
      End Time: #{(start_time + 1.hour).strftime('%l:%M %p')}
    DESC
  end
end

# frozen_string_literal: true

class IcalEventService
  def initialize
    @event = Icalendar::Event.new
  end

  def create_event_from_game(game)
    event_attributes(game).each do |key, value|
      @event.send("#{key}=", value)
    end

    @event
  end

  private

  def event_attributes(game)
    {
      uid: "game-#{game.external_id}",
      description: description(game),
      dtstamp: formatted_time(game.updated_at),
      dtstart: formatted_time(game.start_time),
      dtend: formatted_time(game.end_time),
      location: game.location&.address || "TBD",
      summary: summary(game),
    }
  end

  def description(game)
    text = base_description(game)
    text += "\n\n#{additional_roles_description(game.game_teams)}" if game.game_teams.count > 2
    text += "\n\n#{unverified_location_description}" unless game.location&.verified?
    text
  end

  def base_description(game)
    <<~DESC
      #{summary(game)}

      Field: #{game.field || 'TBD'} - #{game.location&.name || 'TBD'}
      Start Time: #{game.start_time.strftime('%l:%M %p')}
      End Time: #{game.end_time.strftime('%l:%M %p')}
    DESC
  end

  def additional_roles_description(game_teams)
    game_teams.map do |game_team|
      "#{game_team.role.capitalize}: #{game_team.team.name}"
    end.join("\n")
  end

  def formatted_time(time)
    Icalendar::Values::DateTime.new(time.utc)
  end

  def summary(game)
    "#{game.home_team.name} vs. #{game.away_team.name} - #{game.league.title}"
  end

  def unverified_location_description
    "*Note: This location has not been verified. Please double check the address before heading to the game."
  end
end

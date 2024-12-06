# frozen_string_literal: true

class IcalEventService
  SETUP_BUFFER = 15.minutes
  TEARDOWN_BUFFER = 15.minutes
  ROLE_TYPES = %i[home away field_setup field_teardown].freeze

  def initialize
    @event = Icalendar::Event.new
  end

  def create_event_from_game(game, role = nil)
    return unless game.game_teams.any?

    build_event(game, role)
  end

  private

  def build_event(game, role)
    event_attributes(game, role).each do |key, value|
      @event.send("#{key}=", value)
    end
    @event
  end

  def event_attributes(game, role)
    time_calculator = EventTimeCalculator.new(game, role)
    {
      uid: generate_uid(game, role),
      description: build_description(game),
      dtstamp: formatted_time(game.updated_at),
      dtstart: formatted_time(time_calculator.start_time),
      dtend: formatted_time(time_calculator.end_time),
      location: game.location&.address || "TBD",
      summary: build_summary(game, role),
    }
  end

  def generate_uid(game, role)
    "game-#{game.external_id}-#{role}"
  end

  def build_description(game)
    [
      base_description(game),
      additional_roles_text(game),
      unverified_location_warning(game)
    ].compact.join("\n\n")
  end

  def base_description(game)
    <<~DESC.strip
      #{build_summary(game)}

      Field: #{game.field || 'TBD'} - #{game.location&.name || 'TBD'}
      Start Time: #{format_time(game.start_time)}
      End Time: #{format_time(game.end_time)}
    DESC
  end

  def additional_roles_text(game)
    return unless game.game_teams.count > 2

    game.game_teams.map do |game_team|
      "#{format_role(game_team.role)}: #{game_team.team.name}"
    end.join("\n")
  end

  def unverified_location_warning(game)
    return if game.location&.verified?

    "*Note: This location has not been verified. Please double check the address before heading to the game."
  end

  def build_summary(game, role = nil)
    return standard_summary(game) unless should_show_role?(role)

    "#{format_role(role)} - #{standard_summary(game)}"
  end

  def standard_summary(game)
    "#{game.home_team.name} vs. #{game.away_team.name} - #{game.league.title}"
  end

  def should_show_role?(role)
    role && %i[home away].exclude?(role.to_sym)
  end

  def format_role(role)
    role.to_s.capitalize.gsub("_", " ")
  end

  def format_time(time)
    time.strftime("%l:%M %p")
  end

  def formatted_time(time)
    Icalendar::Values::DateTime.new(time)
  end
end

class EventTimeCalculator
  def initialize(game, role)
    @game = game
    @role = role&.to_sym
  end

  def start_time
    case @role
    when :field_setup then @game.start_time - IcalEventService::SETUP_BUFFER
    when :field_teardown then @game.end_time
    else @game.start_time
    end
  end

  def end_time
    case @role
    when :field_setup then @game.start_time
    when :field_teardown then @game.end_time + IcalEventService::TEARDOWN_BUFFER
    else @game.end_time
    end
  end
end

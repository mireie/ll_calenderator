# frozen_string_literal: true

module Parsers
  class GameParser < BaseParser
    def parse(game_data, fields = nil)
      @game_data = game_data
      {
        external_id: parse_external_id,
        start_time: parse_start_time,
        field: parse_field(parse_external_id, fields),
        game_teams: parse_game_teams,
      }
    end

    def parse_game_teams
      {
        home_team_id: @game_data["data-teamoneid"],
        away_team_id: @game_data["data-teamtwoid"],
        officiating_team_name: parse_officiating_team_name,
        content_title: parse_game_content_title,
      }
    end

    private

    def parse_external_id
      @game_data["id"]
    end

    def parse_start_time
      id_parts = parse_external_id.split("_")
      date = id_parts[1]
      time = format_time(id_parts[2])
      convert_to_utc("#{date} #{time}")
    end

    def format_time(time_str)
      time_str.gsub("-", ":")
    end

    def convert_to_utc(datetime_str)
      Time.use_zone("Pacific Time (US & Canada)") do
        Time.zone.parse(datetime_str).utc
      end
    end

    def parse_field(game_id, fields)
      return if fields.nil?

      fields.find { |field| field[:col] == game_id.split("_").last.to_i }
    end

    def parse_officiating_team_name
      return if @game_data.css("div .officiatedBy").blank?

      @game_data.css("div .officiatedBy").text.split(":", 2).last.strip
    end

    def parse_game_content_title
      @game_data.css("div .gameContentTitle").text
    end
  end
end

# frozen_string_literal: true

module Parsers
  class ScheduleParser < BaseParser
    def parse(html)
      @doc = parse_html(html)
      @doc.css("div#leagueSchedule div.gameDate table.scheduleTable").map do |game_date|
        fields = parse_game_fields(game_date)
        game_time_rows = game_date.css("tbody tr")
        game_time_rows.map { |row| parse_game_time_row(row, fields) }
      end
    end

    private

    def parse_game_fields(game_date)
      game_date.css("thead tr th").map.with_index do |field, index|
        next unless field.text.strip!

        {
          col: index,
          name: field_name(field),
          number: field_number(field),
          location_id: field_location_id(field),
        }
      end.compact
    end

    def parse_game_time_row(row, fields)
      row.css("td").map do |game|
        next unless game["data-teamoneid"].present? && game["data-teamtwoid"].present?

        GameParser.new.parse(game, fields)
      end
    end

    def field_name(field)
      field.text.strip.split("\n").first.strip
    end

    def field_number(field)
      field.text.strip.split("\n").last.strip
    end

    def field_location_id(field)
      field.css("a")&.first&.[]("href")&.split("/")&.last
    end
  end
end

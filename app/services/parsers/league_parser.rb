# frozen_string_literal: true

module Parsers
  class LeagueParser < BaseParser
    def parse(html)
      @doc = parse_html(html)
      {
        external_id: parse_external_id,
        title: parse_title,
        sport: parse_sport,
        description: parse_description,
        days: parse_days,
        start_date: parse_start_date,
        end_date: parse_end_date,
      }
    end

    def parse_locations
      @doc.css(".locations a").map do |location|
        {
          external_id: location.attributes["href"].value.split("/").last,
          name: location.text.strip,
        }
      end
    end

    private

    def parse_external_id
      @doc.css(".league-links li a").first.attributes["href"].value.split("/").last
    end

    def parse_title
      @doc.css("h1").text
    end

    def parse_sport
      @doc.css(".league-summary .sport").children.last.text.strip
    end

    def parse_description
      @doc.css(".league-description").text
    end

    def parse_days
      @doc.css(".days").text.split(":").last.strip.split(",").map(&:strip)
    end

    def parse_start_date
      extract_date(@doc.css(".start").text.strip)
    end

    def parse_end_date
      dates = parse_dates
      return nil if dates.blank?

      start_date = parse_start_date
      return nil unless start_date

      dates.map! do |date|
        month, day = date.split(".").map(&:strip)
        year = start_date.year
        # If the date would be before the start date, it must be in the next year
        year += 1 if month.to_i < start_date.month || (month.to_i == start_date.month && day.to_i < start_date.day)
        Date.new(year, month.to_i, day.to_i)
      end.max
    end

    def parse_dates
      @doc.css("li").find { |li| li.text.include?("Dates:") }&.text
        &.split("Dates:")&.last
        &.strip
        &.split(",")
        &.map(&:strip)
    end

    ### Helper methods

    def extract_date(date_string)
      date_pattern = /
        \b(?:Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday),
        \s(?:January|February|March|April|May|June|July|August|September|October|November|December)
        \s\d{1,2}\b
      /x
      match = date_string.match(date_pattern)
      match ? Date.parse(match[0]) : nil
    end
  end
end

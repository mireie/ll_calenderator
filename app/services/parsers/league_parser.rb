# frozen_string_literal: true

module Parsers
  class LeagueParser < BaseParser
    def parse_league_attributes(document)
      @document = document
      {
        title: parse_title,
        sport: parse_sport,
        description: parse_description,
        days: parse_days,
        start_date: parse_start_date,
        end_date: parse_end_date,
        locations: parse_locations,
      }
    end

    private

    def league_details
      @document.css(".league-detail-container")
    end

    def parse_title
      @document.css("h1").text
    end

    def parse_sport
      @document.css(".league-summary .sport").children.last.text.strip
    end

    def parse_description
      @document.css(".league-description").text
    end

    def parse_days
      @document.css(".days").text.split(":").last.strip.split(",").map(&:strip)
    end

    def parse_start_date
      extract_date(@document.css(".start").text.strip)
    end

    def parse_end_date
      dates = @document.css("li").find { |li| li.text.strip.start_with?("Dates:") }.text.split(":").last.strip
      Date.parse(dates.split(",").last.gsub(".", "/").strip) if dates.present?
    end

    def parse_locations
      @document.css(".locations a").map do |location|
        {
          external_id: location.attributes["href"].value.split("/").last,
          name: location.text.strip,
        }
      end
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

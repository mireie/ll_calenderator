# frozen_string_literal: true

module Parsers
  class OrganizationParser < BaseParser
    def name(html)
      @doc = parse_html(html)
      @doc.css("meta[property='og:title']").first["content"]
    end

    def parse_leagues(html)
      @doc = parse_html(html)
      league_docs.map do |league|
        build_league_data(league)
      end
    end

    private

    def league_docs
      @doc.css("div#leagueListingsContainer div.league-listing")
    end

    def build_league_data(league_data)
      {
        title: league_data["data-leaguename"],
        sport: league_data["data-sport"],
        description: league_data.css("p.league-description").first.text.strip,
        days: league_data["data-days"].split(","),
        external_id: league_data["data-leagueid"],
        start_date: Date.parse(league_data.css("li.days").text.split(":").last.strip),
      }
    end
  end
end

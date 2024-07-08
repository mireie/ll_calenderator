# frozen_string_literal: true

module DataServices
  class LeagueDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::LeagueParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def league_attributes(league_url)
      document = @fetcher.fetch_html(league_url)
      @parser.parse_league_attributes(document)
    end
  end
end

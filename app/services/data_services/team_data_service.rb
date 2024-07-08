# frozen_string_literal: true

module DataServices
  class TeamDataService
    def initialize(fetcher: HtmlFetcher.new, parser: TeamParser.new)
      @fetcher = fetcher
      @parser = parser
    end
  end
end

# frozen_string_literal: true

module DataServices
  class GameDataService
    def initialize(fetcher: HtmlFetcher.new, parser: GameParser.new)
      @fetcher = fetcher
      @parser = parser
    end
  end
end

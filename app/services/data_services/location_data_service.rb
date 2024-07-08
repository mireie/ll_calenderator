# frozen_string_literal: true

module DataServices
  class LocationDataService
    def initialize(fetcher: HtmlFetcher.new, parser: LocationParser.new)
      @fetcher = fetcher
      @parser = parser
    end
  end
end

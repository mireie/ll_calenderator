# frozen_string_literal: true

module DataServices
  class OrganizationDataService
    def initialize(fetcher: HtmlFetcher.new, parser: OrganizationParser.new)
      @fetcher = fetcher
      @parser = parser
    end
  end
end

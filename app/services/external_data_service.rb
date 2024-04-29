# frozen_string_literal: true

# The ExternalDataService is responsible for providing data services for external data sources
# such as APIs and websites
module ExternalDataService
  require 'open-uri'

  class << self
    def fetch_and_parse_external_data(url)
      Nokogiri::HTML(URI.parse(url).open)
    end
  end
end

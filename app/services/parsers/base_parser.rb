# frozen_string_literal: true

module Parsers
  class BaseParser
    require "open-uri"

    def fetch_page(url)
      Nokogiri::HTML(URI.parse(url).open)
    end
  end
end

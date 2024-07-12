# frozen_string_literal: true

module Parsers
  class BaseParser
    def parse
      raise NotImplementedError
    end

    def parse_html(html)
      Nokogiri::HTML(html)
    end
  end
end

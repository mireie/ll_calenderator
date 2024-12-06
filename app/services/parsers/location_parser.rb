# frozen_string_literal: true

module Parsers
  class LocationParser < BaseParser
    def parse(html)
      @doc = parse_html(html)
      @doc.css("div#locationDetails .infoWindow").map do |location_data|
        {
          external_id: location_data.attributes["id"]&.value&.split("_")&.last,
          name: location_data.css("h3").inner_text.strip,
          address: clean_address(location_data.css("div.address").inner_text).presence,
        }
      end
    end

    private

    def clean_address(address)
      address.gsub(/[\n\t]/, "").gsub(/\s+/, " ").strip
    end
  end
end

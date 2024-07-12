# frozen_string_literal: true

module Parsers
  class TeamParser < BaseParser
    def parse_standings(html)
      @doc = parse_html(html)
      @doc.css("a.teamPageLink").map do |team|
        {
          external_id: team.attributes["href"].value.split("/")[2],
          name: team.text.strip,
        }
      end
    end
  end
end

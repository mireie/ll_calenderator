# frozen_string_literal: true

module DataServices
  class LocationDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::LocationParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def fetch_and_parse_organization_locations(locations_url)
      html = @fetcher.fetch_html(locations_url)
      parsed_locations = @parser.parse(html)
      parsed_locations.map { |location| create_or_update_location(location) }
    end

    def create_from_field_data(field_data)
      location = Location.find_or_initialize_by(external_id: field_data[:location_id])
      location_attributes = location_attributes(field_data)
      location.assign_attributes(location_attributes)
      location.save if location.changed?
      location
    end

    private

    def create_or_update_location(location_data)
      location = Location.find_or_initialize_by(external_id: location_data[:external_id])
      location.assign_attributes(location_data)
      location.save
      location
    end

    def location_attributes(field_data)
      {
        name: field_data[:name],
        external_id: field_data[:location_id],
      }
    end
  end
end

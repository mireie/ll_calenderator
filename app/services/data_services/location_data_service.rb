# frozen_string_literal: true

module DataServices
  class LocationDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::LocationParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def create_from_field_data(field_data)
      location = Location.find_or_initialize_by(external_id: field_data[:external_id])
      location_attributes = location_attributes(field_data)
      location.assign_attributes(location_attributes)
      location.save if location.changed?
      location
    end

    private

    def location_attributes(field_data)
      {
        name: field_data[:name],
        external_id: field_data[:external_id],
      }
    end
  end
end

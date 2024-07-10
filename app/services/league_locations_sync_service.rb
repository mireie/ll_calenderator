# frozen_string_literal: true

class LeagueLocationsSyncService
  def initialize(league)
    @league = league
    @doc = ExternalDataService.fetch_and_parse_external_data(locations_url)
  end

  class << self
    def sync(league)
      new(league).sync
    end
  end

  def sync
    Parsers::LocationParser.new.parse(@doc).each do |location_data|
      location = Location.find_or_initialize_by(external_id: location_data[:id])
      next if skip_update_location?(location, location_data)

      location.update!(
        {
          name: location_data[:name],
          address: location_data[:address],
          external_id: location_data[:id],
          verified: false,
        }
      )
    end
  end

  private

  def locations_url
    @league.organization.base_url + @league.organization.location_path
  end

  def skip_update_location?(location, location_data)
    location.persisted? &&
      location.verified? &&
      location.name == location_data[:name] &&
      location.address == location_data[:address]
  end
end

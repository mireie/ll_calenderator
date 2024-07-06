# frozen_string_literal: true

class LeagueLocationsSyncService
  def initialize(league)
    @league = league
    @doc = ExternalDataService.fetch_and_parse_external_data(@league.locations_url)
  end

  def sync
    location_details.each do |location_data|
      location = @league.locations.find_or_initialize_by(id: location_data[:id])
      if location.persisted? &&
         location.verified? &&
         location.name == location_data[:name] &&
         location.address == location_data[:address]
        next
      end

      location.update(name: location_data[:name], address: location_data[:address])
    end
  end

  private

  def location_details
    @doc.css("div#locationDetails .infoWindow").map do |location_data|
      {
        id: location_data.attributes["id"]&.value&.split("_")&.last,
        name: location_data.css("h3").inner_text.strip,
        address: clean_address(location_data.css("div.address").inner_text),
      }
    end
  end

  def clean_address(address)
    address.gsub(/[\n\t]/, "").gsub(/\s+/, " ").strip
  end
end

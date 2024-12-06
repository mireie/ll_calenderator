# frozen_string_literal: true

class SyncOrganizationLocationsJob < ApplicationJob
  queue_as :default

  def perform(organization_id)
    organization = Organization.find(organization_id)
    return if organization.location_path.blank?

    organization_locations_url = organization.base_url + organization.location_path
    DataServices::LocationDataService.new.fetch_and_parse_organization_locations(organization_locations_url)
  end
end

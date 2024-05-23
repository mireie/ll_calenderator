# frozen_string_literal: true

# The PullOrganizationLeaguesDataJob is responsible for pulling league data for an organization
class PullOrganizationLeaguesDataJob
  include Sidekiq::Worker

  def perform(organization_id)
    organization = Organization.find(organization_id)
    return if organization.blank?

    OrganizationLeaguesDataService.new(organization).fetch_and_process_external_league_data
  end
end

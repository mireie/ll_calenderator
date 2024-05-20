# frozen_string_literal: true

# The PullOrganizationLeaguesDataJob is responsible for pulling league data for an organization
class PullOrganizationLeaguesDataJob
  include Sidekiq::Worker

  def perform(organization_id)
    Organization.find_by(organization_id).fetch_and_parse_external_league_data
  end
end

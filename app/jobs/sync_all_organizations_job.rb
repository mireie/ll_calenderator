# frozen_string_literal: true

class SyncAllOrganizationsJob
  include Sidekiq::Worker

  def perform
    Organization.pluck(:id).each { |organization_id| OrganizationLeaguesSyncJob.perform_async(organization_id) }
  end
end

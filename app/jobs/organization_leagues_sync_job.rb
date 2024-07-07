# frozen_string_literal: true

class OrganizationLeaguesSyncJob
  include Sidekiq::Worker

  def perform(organization_id)
    Organization.find(organization_id).leagues.each { |league| LeagueScheduleSyncJob.perform_async(league.id) }
  end
end

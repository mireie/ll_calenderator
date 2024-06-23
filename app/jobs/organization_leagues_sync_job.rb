# frozen_string_literal: true

class OrganizationLeaguesSyncJob < ApplicationJob
  queue_as :default

  def perform(organization_id)
    Organization.find(organization_id).leagues.each { |league| LeagueScheduleSyncJob.perform_later(league.id) }
  end
end

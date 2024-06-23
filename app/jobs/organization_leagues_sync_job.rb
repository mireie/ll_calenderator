# frozen_string_literal: true

class OrganizationLeaguesSyncJob < ApplicationJob
  queue_as :default

  def perform(organization)
    organization.leagues.each do |league|
      LeagueSchedueSyncJob.perform_later(league)
    end
  end
end

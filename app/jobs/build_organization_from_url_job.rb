# frozen_string_literal: true

class BuildOrganizationFromUrlJob < ApplicationJob
  def perform(url, paths: {})
    # build organization
    organization = DataServices::OrganizationDataService.new.create_organization(url, paths:)

    # populate leagues
    DataServices::OrganizationDataService.new.populate_leagues(organization)

    # populate teams
    organization.leagues.each do |league|
      DataServices::TeamDataService.new.create_league_teams(league)
      SyncLeagueScheduleJob.perform_later(league)
    end
  end
end

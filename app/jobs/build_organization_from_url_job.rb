# frozen_string_literal: true

class BuildOrganizationFromUrlJob
  include Sidekiq::Worker

  def perform(url, paths: {})
    # build organization
    organization = DataServices::OrganizationDataService.new.create_organization(url, paths:)

    # populate leagues
    DataServices::OrganizationDataService.new.populate_leagues(organization)

    # populate teams
    organization.leagues.each do |league|
      DataServices::TeamDataService.new.create_league_teams(league)

      # populate games
      DataServices::ScheduleDataService.new.parse(league.schedule_url)
    end
  end
end

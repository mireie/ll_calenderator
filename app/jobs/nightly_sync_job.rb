# frozen_string_literal: true

class NightlySyncJob
  include Sidekiq::Worker

  def perform
    # Find new leagues
    Organization.find_each do |organization|
      organization.leagues.find_each do |league|
        next if league.external_id.blank?

        DataServices::TeamDataService.new.create_league_teams(league)
        ParseScheduleJob.perform_async(league.id)
      end
    end
  end
end

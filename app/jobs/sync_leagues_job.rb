# frozen_string_literal: true

class SyncLeaguesJob
  include Sidekiq::Worker

  def perform
    Organization.find_each do |organization|
      DataServices::OrganizationDataService.new.populate_leagues(organization)
    end
    League.find_each do |league|
      DataServices::ScheduleDataService.new.parse(league.schedule_url)
      DataServices::ScheduleDataService.new.cleanup_removed_games(league.schedule_url)
    end
  end
end

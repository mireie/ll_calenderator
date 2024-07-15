# frozen_string_literal: true

class SyncLeaguesJob
  include Sidekiq::Worker

  def perform
    Organization.find_each do |organization|
      DataServices::OrganizationDataService.new.populate_leagues(organization)
    end
    League.pluck(:id).each do |league_id|
      ParseScheduleJob.perform_async(league_id)
    end
  end
end

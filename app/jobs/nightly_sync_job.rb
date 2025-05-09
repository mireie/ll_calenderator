# frozen_string_literal: true

class NightlySyncJob < ApplicationJob
  def perform
    league_update_jobs = []
    league_update_jobs << League.upcoming.each do |league|
      SyncLeagueDetailsJob.perform_later(league)
      SyncLeagueScheduleJob.perform_later(league)
    end
    league_update_jobs << League.active.each do |league|
      SyncLeagueDetailsJob.perform_later(league)
    end
    ActiveJob.perform_all_later(league_update_jobs)
  end
end

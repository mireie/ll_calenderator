# frozen_string_literal: true

class NightlySyncJob < ApplicationJob
  def perform
    league_update_jobs = League.all.map { |league| SyncLeagueScheduleJob.new(league) }
    ActiveJob.perform_all_later(league_update_jobs)
  end
end

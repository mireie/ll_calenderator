# frozen_string_literal: true

class NightlySyncJob < ApplicationJob
  def perform
    League.upcoming.each do |league|
      SyncLeagueDetailsJob.perform_later(league)
      SyncLeagueScheduleJob.perform_later(league)
    end

    League.active.each do |league|
      SyncLeagueDetailsJob.perform_later(league)
    end
  end
end

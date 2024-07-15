# frozen_string_literal: true

class SyncLeagueGamesJob
  include Sidekiq::Worker

  def perform
    League.find_each { |league| ParseScheduleJob.perform_async(league.id) }
    nil
  end
end

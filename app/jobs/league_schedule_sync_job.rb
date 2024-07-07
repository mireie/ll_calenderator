# frozen_string_literal: true

class LeagueScheduleSyncJob
  include Sidekiq::Worker

  def perform(league_id)
    LeagueScheduleSyncService.sync(League.find(league_id))
  end
end

# frozen_string_literal: true

class LeagueLocationsSyncJob
  include Sidekiq::Worker

  def perform(league_id)
    LeagueLocationsSyncService.sync(League.find(league_id))
  end
end

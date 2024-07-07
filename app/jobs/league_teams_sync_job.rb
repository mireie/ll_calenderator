# frozen_string_literal: true

class LeagueTeamsSyncJob
  include Sidekiq::Worker

  def perform(league_id)
    LeagueTeamsSyncService.sync(League.find(league_id))
  end
end

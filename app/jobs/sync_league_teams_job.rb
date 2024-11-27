# frozen_string_literal: true

class SyncLeagueTeamsJob
  include Sidekiq::Worker

  def perform(league_id)
    league = League.find(league_id)
    DataServices::TeamDataService.new.create_league_teams(league)
  end
end

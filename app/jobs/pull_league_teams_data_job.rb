# frozen_string_literal: true

class PullLeagueTeamsDataJob
  include Sidekiq::Worker

  def perform(league_id)
    LeagueTeamsDataService.new(League.find(league_id)).fetch_and_process_external_team_data
  end
end

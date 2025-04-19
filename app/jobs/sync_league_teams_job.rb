# frozen_string_literal: true

class SyncLeagueTeamsJob < ApplicationJob
  def perform(league)
    DataServices::TeamDataService.new.create_league_teams(league)
  end
end

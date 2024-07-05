# frozen_string_literal: true

class LeagueTeamsSyncJob < ApplicationJob
  queue_as :default

  def perform(league_id)
    LeagueTeamsSyncService.sync(League.find(league_id))
  end
end

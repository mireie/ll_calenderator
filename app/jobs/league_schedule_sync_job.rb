# frozen_string_literal: true

class LeagueScheduleSyncJob < ApplicationJob
  queue_as :default

  def perform(league_id)
    LeagueScheduleSyncService.sync(League.find(league_id))
  end
end

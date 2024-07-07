# frozen_string_literal: true

class LeagueLocationsSyncJob < ApplicationJob
  queue_as :default

  def perform(league_id)
    LeagueLocationsSyncService.sync(League.find(league_id))
  end
end

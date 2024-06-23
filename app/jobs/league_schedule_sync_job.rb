# frozen_string_literal: true

class LeagueScheduleSyncJob < ApplicationJob
  queue_as :default

  def perform(league)
    league.sync_schedule
  end
end

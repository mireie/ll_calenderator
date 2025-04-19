# frozen_string_literal: true

class SyncLeagueScheduleJob < ApplicationJob
  def perform(league)
    league.sync_schedule
  end
end

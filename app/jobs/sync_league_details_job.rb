# frozen_string_literal: true

class SyncLeagueDetailsJob < ApplicationJob
  def perform(league)
    league.sync_details
  end
end

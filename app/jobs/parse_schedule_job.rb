# frozen_string_literal: true

class ParseScheduleJob < ApplicationJob
  def perform(league_id)
    league = League.find(league_id)
    DataServices::ScheduleDataService.new.parse(league.schedule_url)
    DataServices::ScheduleDataService.new.cleanup_removed_games(league.schedule_url)
  end
end

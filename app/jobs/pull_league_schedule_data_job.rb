# frozen_string_literal: true

# The PullLeagueScheduleDataJob is responsible for pulling schedule data for a league
class PullLeagueScheduleDataJob
  include Sidekiq::Worker

  def perform(league_id)
    LeagueScheduleDataService.new(League.find(league_id)).fetch_and_process_external_schedule_data
  end
end

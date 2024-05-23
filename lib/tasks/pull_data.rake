# frozen_string_literal: true

namespace :pull_data do
  desc "Pull all data for organizations."
  task all: :environment do
    Organization.select(:id).find_each do |organization|
      PullOrganizationLeaguesDataJob.perform_async(organization.id)
    end
    League.select(:id).find_each do |league|
      PullLeagueScheduleDataJob.perform_async(league.id)
    end
  end
end

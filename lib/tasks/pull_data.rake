# frozen_string_literal: true

namespace :pull_data do
  desc "Pull all data for organizations."
  task :all do
    Organization.find_each do |organization|
      PullOrganizationDataJob.perform_async(organization.id)
    end
  end
end

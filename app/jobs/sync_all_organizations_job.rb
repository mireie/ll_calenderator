# frozen_string_literal: true

class SyncAllOrganizationsJob < ApplicationJob
  queue_as :default

  def perform
    Organization.find_each do |organization|
      OrganizationLeaguesSyncJob.perform_later(organization)
    end
  end
end

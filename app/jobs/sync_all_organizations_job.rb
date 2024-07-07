# frozen_string_literal: true

class SyncAllOrganizationsJob < ApplicationJob
  queue_as :default

  def perform
    Organization.pluck(:id).each { |organization_id| OrganizationLeaguesSyncJob.perform_later(organization_id) }
  end
end

# frozen_string_literal: true

class SyncLeaguesJob < ApplicationJob
  def perform
    Organization.find_each do |organization|
      DataServices::OrganizationDataService.new.populate_leagues(organization)
    end
  end
end

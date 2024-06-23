# frozen_string_literal: true

require "rails_helper"

describe SyncAllOrganizationsJob, type: :job do
  describe "#perform" do
    it "enqueues OrganizationLeaguesSyncJob for each organization" do
      create_list(:organization, 3)
      expect(OrganizationLeaguesSyncJob).to receive(:perform_later).exactly(3).times

      described_class.perform_now
    end
  end
end

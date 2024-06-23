# frozen_string_literal: true

require "rails_helper"

describe OrganizationLeaguesSyncJob, type: :job do
  describe "#perform" do
    let(:organization) { create(:organization) }
    let(:league) { create(:league, organization:) }

    it "syncs all leagues for an organization" do
      expect(LeagueScheduleSyncJob).to receive(:perform_later).with(league.id)
      OrganizationLeaguesSyncJob.new.perform(organization.id)
    end
  end
end

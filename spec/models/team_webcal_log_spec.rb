# frozen_string_literal: true

require "rails_helper"

RSpec.describe TeamWebcalLog, type: :model do
  describe "associations" do
    it "belongs to a team" do
      team = create(:team)

      log = described_class.create!(team: team, ip_address: "127.0.0.1", user_agent: "Safari")

      expect(log.team).to eq(team)
    end
  end

  describe ".hits_by_team" do
    it "counts how many times each team was accessed" do
      team_one = create(:team)
      team_two = create(:team)

      create_list(:team_webcal_log, 2, team: team_one)
      create(:team_webcal_log, team: team_two)

      expect(described_class.hits_by_team).to eq({ team_one.id => 2, team_two.id => 1 })
    end
  end
end

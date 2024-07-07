# frozen_string_literal: true

# The Organization model is responsible for the top-level organization that is responsible for the
# leagues, teams, and games
class Organization < ApplicationRecord
  has_many :leagues, dependent: :destroy
  has_many :teams, through: :leagues
  has_many :games, through: :leagues
  has_many :locations, dependent: :nullify

  enum status: { inactive: 0, active: 1 }

  scope :active, -> { where(status: :active) }
  default_scope { active }

  class << self
    def create_and_populate_organization_from_url(base_url)
      organization = Organization.find_or_create_by(base_url:)
      assign_organization_attributes(organization, base_url) if organization.new_record?

      organization.leagues.find_each do |league|
        LeagueDataService.new(league).fetch_and_process_external_team_data
        ScheduleDataService.new(league).fetch_and_process_external_schedule_data
      end
    end

    private

    def assign_organization_attributes(organization, base_url)
      organization.assign_attributes(
        name: base_url,
        leagues_path: "/league",
        teams_path: "/team",
        location_path: "/location"
      )
      organization.save
    end
  end
end

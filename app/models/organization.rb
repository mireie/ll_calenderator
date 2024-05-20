# frozen_string_literal: true

# The Organization model is responsible for the top-level organization that is responsible for the
# leagues, teams, and games
class Organization < ApplicationRecord
  has_many :leagues, dependent: :destroy
  has_many :teams, through: :leagues
  has_many :games, through: :leagues
  has_many :locations

  enum status: { inactive: 0, active: 1 }

  scope :active, -> { where(status: :active) }
  default_scope { active }

  def self.create_and_populate_organization_from_url(base_url)
    organization = Organization.find_or_create_by(base_url:)
    if organization.new_record?
      organization.name = base_url
      organization.leagues_path = "/league"
      organization.teams_path = "/team"
      organization.save
    end

    OrganizationDataService.new(organization).fetch_and_process_external_league_data
    organization.leagues.each do |league|
      LeagueDataService.new(league).fetch_and_process_external_team_data
      ScheduleDataService.new(league).fetch_and_process_external_schedule_data
    end
  end

  # TODO: Extract this
  def publish_calendars
    FileUtils.mkdir_p("public/organizations/#{id}")

    League.includes(:teams, :games).where(organization_id: id).find_each do |league|
      league.teams.find_each do |team|
        FileUtils.mkdir_p("public/organizations/#{id}/#{league.external_id}")
        File.open("public/organizations/#{id}/#{league.external_id}/#{team.external_id}.ics", "w") do |f|
          f.write(team.games_to_ical)
        end
      end
    end
  end
end

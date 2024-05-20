# frozen_string_literal: true

# The LeagueTeamsDataService is responsible for fetching and processing teams data for a league
class LeagueTeamsDataService
  def initialize(league)
    @league = league
    @organization = league.organization
  end

  def fetch_and_process_external_team_data
    fetch_teams.each { |team_data| create_or_update_team(team_data) }
  end

  private

  def league_url
    "#{@organization.base_url}/league/#{@league[:external_id]}"
  end

  def fetch_teams
    path = "#{league_url}/standings"
    ExternalDataService.fetch_and_parse_external_data(path)
      .css("table.divisionStandings tbody tr")
      .to_ary.select { |team_data| team_data.css("td.teamName a").any? }
  end

  def create_or_update_team(team_data)
    team_attributes = team_attributes(team_data)
    team = Team.find_or_initialize_by(external_id: team_attributes[:external_id])
    team.update(team_attributes)
    team.save
  end

  def external_team_id(team_data)
    # /team/{team-id}/{team-name}
    team_data.css("td.teamName a").first.attributes["href"].value.split("/")[2]
  end

  def team_attributes(team_data)
    {
      league: @league,
      name: team_data.css("td.teamName a").first.text.strip,
      external_id: external_team_id(team_data),
    }
  end
end

# frozen_string_literal: true

class LeagueTeamsSyncService
  def initialize(league)
    @league = league
  end

  def sync
    fetch_teams.each { |team_data| create_or_update_team(team_data) }
  end

  class << self
    def sync(league)
      new(league).sync
    end
  end

  private

  def fetch_teams
    path = "#{@league.url}/standings"
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

# frozen_string_literal: true

module DataServices
  class TeamDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::TeamParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def create_league_teams(league)
      document = @fetcher.fetch_html(league.standings_url)
      @parser.parse_standings(document).each do |team_data|
        create_team(team_data, league)
      end
    end

    private

    def create_team(team_data, league)
      team = Team.find_or_initialize_by(external_id: team_data[:external_id])
      return team if team.persisted?

      team_attributes = team_attributes(team_data, league)
      team.assign_attributes(team_attributes)
      team.save!
      team
    end

    def team_attributes(team_data, league)
      {
        league:,
        name: team_data[:name],
        external_id: team_data[:external_id],
      }
    end
  end
end

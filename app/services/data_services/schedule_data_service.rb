# frozen_string_literal: true

module DataServices
  class ScheduleDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::ScheduleParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def parse(schedule_url)
      document = @fetcher.fetch_html(schedule_url)
      parsed_game_data = @parser.parse(document).flatten.compact
      parsed_game_data.each do |game_data|
        game = Game.find_or_initialize_by(external_id: game_data[:external_id])
        if game.persisted?
          update_game(game, game_data)
          next
        end
        create_game(game, game_data, schedule_url)
      end
    end

    def cleanup_removed_games(schedule_url)
      league = league_from_url(schedule_url)
      return if league.blank?

      schedule_game_ids = game_ids_from_schedule(schedule_url)

      league.games.find_each do |game|
        game.update(status: :removed) unless game.external_id.in?(schedule_game_ids)
      end
    end

    private

    def create_game(game, game_data, schedule_url)
      game.league = league_from_url(schedule_url)
      game.assign_attributes(game_attributes(game_data))
      game.location = parse_location(game_data[:field])
      game.save
      assign_game_teams(game, game_data[:game_teams]) if game.persisted?
    end

    def update_game(game, game_data)
      game.assign_attributes(game_attributes(game_data))
      game.location = parse_location(game_data[:field])
      game.save
      assign_game_teams(game, game_data[:game_teams]) if game.persisted?
    end

    def league_from_url(url)
      league_id = url.split("/")[-2]
      League.find_by(external_id: league_id)
    end

    def assign_game_teams(game, game_teams_data)
      assign_home_team(game, Team.find_by(external_id: game_teams_data[:home_team_id]))
      assign_away_team(game, Team.find_by(external_id: game_teams_data[:away_team_id]))
      assign_officiating_team(game, Team.find_by(name: game_teams_data[:officiating_team_name]))
      assign_teams_from_content_title(game, game_teams_data[:content_title])
    end

    def assign_home_team(game, home_team)
      return if home_team.blank?

      GameTeam.find_or_create_by(game:, team: home_team, role: :home)
    end

    def assign_away_team(game, away_team)
      return if away_team.blank?

      GameTeam.find_or_create_by(game:, team: away_team, role: :away)
    end

    def assign_officiating_team(game, officiating_team)
      return if officiating_team.blank?

      GameTeam.find_or_create_by(game:, team: officiating_team, role: :officiating)
    end

    def assign_teams_from_content_title(game, content_title)
      return if content_title.blank? || content_title.exclude?(":")

      role = content_title.split(":", 2).first.strip.downcase.split.join("_").to_sym
      team_name = content_title.split(":", 2).last.strip
      team = Team.find_by(name: team_name)
      return if team.blank?

      GameTeam.find_or_create_by(game:, team:, role:)
    end

    def game_attributes(game_data)
      {
        external_id: game_data[:external_id],
        start_time: game_data[:start_time],
        field: game_data[:field][:number],
        status: :scheduled,
      }
    end

    def parse_location(field)
      return if field.blank?

      location = Location.find_by(external_id: field[:location_id])
      return location if location

      DataServices::LocationDataService.new.create_from_field_data(field)
    end

    def game_ids_from_schedule(schedule_url)
      document = @fetcher.fetch_html(schedule_url)
      @parser.parse(document).flatten.compact.pluck(:external_id)
    end
  end
end

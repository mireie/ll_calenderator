# frozen_string_literal: true

class LeagueScheduleSyncService
  def initialize(league)
    @league = league
  end

  def sync
    fetch_schedule.each { |game_date| proccess_game_date(game_date) }
  end

  class << self
    def sync(league)
      new(league).sync
    end
  end

  private

  def schedule_url
    base_url = @league.organization.base_url
    league_id = @league.external_id
    "#{base_url}/league/#{league_id}/schedule"
  end

  def fetch_schedule
    doc = ExternalDataService.fetch_and_parse_external_data(schedule_url)
    doc.css("div#leagueSchedule div.gameDate table.scheduleTable")
  end

  def proccess_game_date(game_date)
    game_fields = field_data_for_game_date(game_date.css("thead tr th"))
    game_date.css("tbody tr").each { |row| proccess_game_time_row(row, game_fields) }
  end

  def field_data_for_game_date(game_fields)
    game_fields.map.with_index do |field, index|
      next unless field.text.strip!

      {
        col: index,
        name: field_name(field),
        number: field_number(field),
        location_id: field_location_id(field),
      }
    end.compact
  end

  def field_name(field)
    field.text.strip.split("\n").first.strip
  end

  def field_number(field)
    field.text.strip.split("\n").last.strip
  end

  def field_location_id(field)
    field.css("a")&.first&.[]("href")&.split("/")&.last
  end

  # TODO: This should be its own service object or multiple service objects
  def proccess_game_time_row(row, game_fields)
    row.css("td").each do |game|
      next if game.css("div")&.text&.strip&.empty?

      game_attributes = build_game_data(game.attributes)
      next if [game_attributes[:team_one_id], game_attributes[:team_two_id]].any?(&:empty?)

      game_attributes[:field] = game_field_for_game_from_id(game_attributes[:external_id], game_fields)
      game_attributes[:additional_roles] = {}
      # assign officials if available
      if game.css("div .officiatedBy").present?
        officials_team_name = game.css("div .officiatedBy").text.split(":", 2).last.strip
        officials_team = Team.find_by(name: officials_team_name)
        game_attributes[:additional_roles][:officials] = officials_team if officials_team.present?
      end
      # assign additional roles if available, this is a hacky way to do it and only for OKC right now
      # This will only work for a format like: "Field Setup: Team 1"
      if game.css("div .gameContentTitle").present?
        additional_roles = game.css("div .gameContentTitle").text.split(":", 2)
        additional_role_team_name = additional_roles.last.strip
        additional_role_team = Team.find_by(name: additional_role_team_name)
        if additional_role_team.present?
          game_attributes[:additional_roles][additional_roles.first.downcase.to_sym] =
            additional_role_team
        end
      end
      create_or_update_game(game_attributes)
    end
  end

  def build_game_data(game_attributes)
    {
      external_id: game_attributes["id"].value,
      team_one_id: game_attributes["data-teamoneid"].value,
      team_two_id: game_attributes["data-teamtwoid"].value,
      datetime: game_datetime_from_id(game_attributes["id"].value),
    }
  end

  def game_datetime_from_id(game_id)
    id_parts = game_id.split("_")
    date = id_parts[1]
    time = id_parts[2].gsub("-", ":")
    # TODO: Add support for timezone, currently using the default timezone (Pacific Time)
    Time.zone.parse("#{date} #{time}")
  end

  def game_field_for_game_from_id(game_id, game_fields)
    game_fields.find { |field| field[:col] == game_id.split("_")[-1].to_i }
  end

  # TODO: Shouldn't be creating teams here
  def create_or_update_game(game_data)
    game = Game.find_or_initialize_by(external_id: game_data[:external_id])
    home_team = Team.find_or_create_by(external_id: game_data[:team_one_id], league: @league)
    away_team = Team.find_or_create_by(external_id: game_data[:team_two_id], league: @league)
    game.update!(
      league: @league,
      field: game_data[:field]&.[](:number),
      start_time: game_data[:datetime],
      home_team_id: home_team.id,
      away_team_id: away_team.id,
      location: Location.find_by(external_id: game_data[:field]&.[](:location_id))
    )
    game.support_team_roles.destroy_all
    game_data[:additional_roles].each do |role, team|
      game.support_team_roles.create!(team:, role:)
    end
  end
end

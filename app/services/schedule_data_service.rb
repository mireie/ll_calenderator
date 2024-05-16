# frozen_string_literal: true

class ScheduleDataService
  def initialize(league)
    @league = league
  end

  def fetch_and_process_external_schedule_data
    fetch_schedule.each { |game_date| proccess_game_date(game_date) }
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
        location_id: field_location_id(field)
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

  def proccess_game_time_row(row, game_fields)
    row.css("td").each do |game|
      next if game.css("div")&.text&.strip&.empty?

      game_attributes = build_game_data(game.attributes)
      next if game_attributes[:team_one_id].empty? || game_attributes[:team_two_id].empty?

      game_attributes[:field] = game_field_for_game_from_id(game_attributes[:external_id], game_fields)
      create_or_update_game(game_attributes)
    end
  end

  def build_game_data(game_attributes)
    {
      external_id: game_attributes["id"].value,
      team_one_id: game_attributes["data-teamoneid"].value,
      team_two_id: game_attributes["data-teamtwoid"].value,
      datetime: game_datetime_from_id(game_attributes["id"].value)
    }
  end

  def game_datetime_from_id(game_id)
    id_parts = game_id.split("_")
    date = id_parts[1]
    time = id_parts[2].gsub("-", ":")
    # TODO: - add support for timezones
    time_zone = Time.now.zone
    Time.parse("#{date} #{time} #{time_zone}")
  end

  def game_field_for_game_from_id(game_id, game_fields)
    game_fields.find { |field| field[:col] == game_id.split("_")[-1].to_i }
  end

  def create_or_update_game(game_data)
    game = Game.find_or_initialize_by(external_id: game_data[:external_id])
    # TODO: - add support for location
    # game.location_id = Location.find_or_create_by(external_id: game_data[:field][:location_id]).id
    game.league = @league
    game.field = game_data[:field]&.[](:number)
    game.start_time = game_data[:datetime]
    game.home_team_id = Team.find_or_create_by(external_id: game_data[:team_one_id]).id
    game.away_team_id = Team.find_or_create_by(external_id: game_data[:team_two_id]).id

    game.save!
  end
end

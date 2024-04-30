# frozen_string_literal: true

# The TeamDataService is responsible for providing data services for the Team model
class TeamDataService
  def initialize(team)
    @team = team
    @league = team.league
    @organization = @league.organization
  end

  def fetch_and_process_external_game_data
    fetch_dates.each { |game_data| process_date(date_data) }
  end

  private

  def fetch_dates
    path = "#{@organization.base_url}/team/#{@team.external_id}"
    ExternalDataService.fetch_and_parse_external_data(path)
      .css("table#teamScheduleTable tbody tr")
      .to_ary
      .select { |game_data| game_data.attributes["id"]&.value&.start_with?("game_") }
  end

  def process_date(date_data)
    date_data.css
  end
end

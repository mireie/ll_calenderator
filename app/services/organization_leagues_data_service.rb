# frozen_string_literal: true

# The OrganizationLeaguesDataServices is responsible for creating and updating league data from an organization
class OrganizationLeaguesDataService
  def initialize(organization)
    @organization = organization
  end

  def fetch_and_process_external_league_data
    fetch_leagues.each { |league| proccess_league(league) }
  end

  private

  def build_league_data(league, league_attributes)
    {
      organization: @organization,
      title: league_attributes["data-leaguename"],
      sport: league_attributes["data-sport"],
      description: league.css("p.league-description").first.text.strip,
      days: league_attributes["data-days"].split(","),
      external_id: league_attributes["data-leagueid"],
      start_date: Date.parse(league.css("li.days").text.split(":").last.strip),
    }
  end

  def create_or_update_league(league_data)
    league = League.find_or_initialize_by(external_id: league_data[:external_id])
    league.update(league_data)
    league.save
  end

  def extract_league_attributes(league)
    league_attributes = {}
    league.attributes.each_value do |attribute|
      league_attributes[attribute.name] = attribute.value
    end
    league_attributes
  end

  def fetch_leagues
    doc = ExternalDataService.fetch_and_parse_external_data(leagues_url)
    doc.css("div#leagueListingsContainer div.league-listing")
  end

  def leagues_url
    @organization.base_url + @organization.leagues_path
  end

  def proccess_league(league)
    league_attributes = extract_league_attributes(league)
    league_data = build_league_data(league, league_attributes)
    create_or_update_league(league_data)
  end
end

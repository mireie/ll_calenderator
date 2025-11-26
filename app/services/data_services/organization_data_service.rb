# frozen_string_literal: true

module DataServices
  class OrganizationDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::OrganizationParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def create_organization(organization_url, paths: {})
      @organization = Organization.find_or_initialize_by(base_url: base_url(organization_url))
      return @organization if @organization.persisted?

      @organization.name = @organization.base_url
      org_paths(paths).each do |key, value|
        @organization[key] = value
      end
      html = @fetcher.fetch_html(organization_url)
      @organization.name = @parser.name(html)
      @organization.save!
      @organization
    end

    def populate_leagues(organization = nil)
      @organization ||= organization
      return unless @organization

      # TODO: Handle this without special case for OKC
      handle_okc and return if okc?

      process_leagues
    end

    private

    def okc?
      @organization.base_url == "oregonkickballclub.leaguelab.com"
    end

    def handle_okc
      DataServices::LeagueDataService.new.create_league(@organization.leagues_url)
    end

    def process_leagues
      league_data = fetch_league_data
      league_data.each { |league_attributes| create_or_update_league(league_attributes) }

      # TODO: handle current leagues
      current_leagues = @parser.parse_leagues(@fetcher.fetch_html("#{@organization.leagues_url}?v=current"))
      current_leagues.each { |league_attributes| create_or_update_league(league_attributes) }
    end

    def fetch_league_data
      @parser.parse_leagues(@fetcher.fetch_html(@organization.leagues_url))
    end

    def create_or_update_league(league_attributes)
      league = League.find_or_initialize_by(external_id: league_attributes[:external_id])
      return if league.persisted?

      league.organization = @organization
      league.assign_attributes(league_attributes)
      league.save if league.changed?
    end

    def base_url(url)
      URI.parse(url).host
    end

    def org_paths(paths)
      {
        leagues_path: paths[:leagues_path] || Organization::DEFAULT_LEAGUES_PATH,
        teams_path: paths[:teams_path] || Organization::DEFAULT_TEAMS_PATH,
        schedule_path: paths[:schedule_path] || Organization::DEFAULT_SCHEDULE_PATH,
        location_path: paths[:location_path] || Organization::DEFAULT_LOCATION_PATH,
      }
    end
  end
end

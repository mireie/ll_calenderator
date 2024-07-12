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
      populate_leagues(html)
    end

    def populate_leagues(organization = nil)
      @organization ||= organization
      return unless @organization

      # TODO: Handle this without special case for OKC
      if @organization.base_url == "oregonkickballclub.leaguelab.com"
        DataServices::LeagueDataService.new.create_league(@organization.leagues_url)
        return
      end
      return unless html

      league_docs = @parser.leagues_docs(html)
      league_docs.each do |doc|
        league = League.find_or_initialize_by(external_id: doc[:external_id])
        next if league.persisted?

        league.update(doc)
        league.save
      end
    end

    private

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

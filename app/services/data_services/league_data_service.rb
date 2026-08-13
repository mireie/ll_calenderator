# frozen_string_literal: true

module DataServices
  class LeagueDataService
    def initialize(fetcher: HtmlFetcher.new, parser: Parsers::LeagueParser.new)
      @fetcher = fetcher
      @parser = parser
    end

    def create_league(league_details_url)
      organization = find_organization_by_league_url(league_details_url)
      raise "Organization not found for league url: #{league_details_url}" unless organization

      attributes = league_attributes(league_details_url)
      league = League.find_or_initialize_by(external_id: attributes[:external_id])
      league.assign_attributes(attributes)
      league.organization = organization if league.new_record?
      league.save if league.changed?
      league
    end

    def league_attributes(league_details_url)
      document = @fetcher.fetch_html(league_details_url)
      @parser.parse(document)
    end

    private

    def find_organization_by_league_url(league_url)
      league_url = "https://#{league_url}" unless league_url.start_with?("http")
      organizations = Organization.where("base_url LIKE ?", "%#{URI.parse(league_url).host}%")
      organizations.first if organizations.present? && organizations.one?
    end
  end
end

# find last updated game
Game.order(updated_at: :desc).first

# frozen_string_literal: true

class HtmlFetcher
  require "open-uri"

  def fetch_html(url)
    url = "https://#{url}" unless url.start_with?("http")
    URI.parse(url).open.read
  rescue OpenURI::HTTPError => e
    # Handle HTTP errors (e.g., 404, 500) here
    Rails.logger.debug { "Failed to open URL: #{e.message}" }
  rescue StandardError => e
    # Handle other potential errors (e.g., network issues) here
    Rails.logger.debug { "An error occurred: #{e.message}" }
  end
end

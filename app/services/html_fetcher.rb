# frozen_string_literal: true

class HtmlFetcher
  def fetch_html(url)
    Nokogiri::HTML(URI.parse(url).open)
  end
end

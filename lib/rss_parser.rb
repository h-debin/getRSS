class RSSParser
  require "json"
  require "crack"
  require 'open-uri'
  require "nokogiri"
  require "iconv"

  def self.parse(url:)
    raise "Exceptino: no url given" if url == nil

    begin
      entire_hash = Crack::XML.parse(open(url).read)
      return entire_hash["rss"]["channel"]["item"]
    rescue
      return [];
    end
  end
end

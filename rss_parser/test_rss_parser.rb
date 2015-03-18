require_relative 'rss_parser'

describe RSSParser do
  it "should raise an error" do
    expect { RSSParser.parse }.to raise_error
  end

  it "should get some news" do
    expect(RSSParser.parse(url:"http://news.163.com/special/00011K6L/rss_newstop.xml")).to equal("a")
  end
end

require_relative 'readability'

describe Readability do
  it "should be able to get content of article" do
    expect(Readability.content_of_article(url:"http://news.163.com/15/0313/17/AKJR7NAE00014SEH.html")).to eq('')
  end
end

require_relative 'tokenizer'

describe Tokenizer do
  before do
    @t = Tokenizer.new
  end

  it "should cut a sentence to words" do
    text = "我是好人"
    puts @t.tokenize(text: text);
  end
end

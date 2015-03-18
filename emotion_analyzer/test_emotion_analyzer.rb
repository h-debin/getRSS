require_relative 'emotion_analyzer'

describe EmotionAnalyzer do
  before do
    @ea = EmotionAnalyzer.new
  end

  it "should get analyze result" do
    puts @ea.analyze(word: "惧怕")
  end
end

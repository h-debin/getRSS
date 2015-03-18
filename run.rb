#!/usr/bin/env ruby

require_relative 'tokenizer/tokenizer'
require_relative 'emotion_analyzer/emotion_analyzer'
require_relative 'rss_parser/rss_parser'
require_relative 'readability/readability'

rss_list = JSON.parse(File.read('rss.json'))
["society", "technology", "sports", "entertainment", "uncategory"].each do |category|
  rss_list[category].each do |url|
    RSSParser.parse(url: url).each do |news|
      emotions = EmotionAnalyzer.on(url: news["link"])
    end
  end
end

__END__

def calculte_text_emotion(text:)
  begin
    words = Tokenizer.tokenize(text: text)
    emotions = []
    words.each do |word|
      emotion = EmotionAnalyzer.analyze_brief(word: word)
      if emotion
        emotions << emotion
      else
        #puts "no such word #{word}"
      end
    end
    max = emotions[0]
    emotions.each do |e|
      if e['level'].abs >= max['level']
        max = e
      end
    end
    puts text
    puts max
  rescue
    return nil
  end
end


require_relative 'emotion_analyzer/emotion_analyzer'

puts ARGV[0]
puts EmotionAnalyzer.new.analyze(word: ARGV[0])

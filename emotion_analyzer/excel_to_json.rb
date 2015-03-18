#!/usr/bin/env ruby

require 'creek'
require 'json'
require 'redis'
require 'json'

creek = Creek::Book.new "emotion_data.xlsx"
sheet= creek.sheets[0]
redis = Redis.new(:port => 4568)

emotion_database = {}
sheet.rows.each do |row|
  #puts row # => {"A1"=>"Content 1", "B1"=>nil, C1"=>nil, "D1"=>"Content 3"}
  word = {}
  row.each_pair do |k, v|
    if k =~ /^A/
      word['text'] = v
    elsif k =~ /^B/
      word['cixing'] = v
    elsif k =~ /^C/
      word['mean_total'] = v
    elsif k =~ /^D/
      word['mean_no']
    elsif k =~ /^E/
      word['emotion_category'] = v
    elsif k =~ /^F/
      word['emotion_level'] = v
    elsif k =~ /^G/
      word['emotion_polarity'] = v
    elsif k =~ /^H/
      word['emotion_category_extra'] = v
    elsif k =~ /^I/
      word['emotion_level_extra'] = v
    elsif k =~ /^J/
      word['emotion_polarity_extra'] = v
    else
      word['extra_info'] ||= [] 
      word['extra_info'] << "#{k} -> #{v}"
    end
  end
    emotion_database[word['text']] =  word
    redis.set(word['text'], word)
end


#File.open("emotion_database.json", "w") do |file|
#  file.puts emotion_database.to_json
#end


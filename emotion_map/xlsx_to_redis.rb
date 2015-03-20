#!/usr/bin/env ruby

require 'creek'
require 'json'
require 'redis'
require 'json'

def xlsx_to_hash
  creek = Creek::Book.new(File.absolute_path("../emotion_map.xlsx", __FILE__))
  sheet= creek.sheets[0]
  emotion_database = {}
  sheet.rows.each do |row|
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
  end
  emotion_database
end

redis = Redis.new(:port => 4568)
if redis.exists("emotion:hash")
  puts "it seems like you have init the emotion hash in redis"
  exit 0
else
  redis.set('emotion:hash', xlsx_to_hash)
end


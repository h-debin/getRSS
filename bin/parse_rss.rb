#!/usr/bin/env ruby

require_relative '../config/environment'

redis = Redis.new(:port => 4568)
rss_list = JSON.parse(File.read('rss.json'))
rss_list.each do |url|
  RSSParser.parse(url: url).each do |news|
    if !redis.sismember('url:visited', news)
      if redis.sadd('url:visited', news)
        puts "saved to redis done"
        if redis.lpush('url:to_analyze', news)
          puts "put url to to_analyze queue done"
        else
          puts "put url to to_analyze queue failed"
        end
      else
        puts "saved to redis failed"
      end
    else
      puts "url already in visited url"
    end
  end
end

#!/usr/bin/env ruby

require_relative '../config/environment'

redis = Redis.new(:port => 4568)
while redis.llen("url:to_analyze") != 0
  threads = []
  10.times do
    threads << Thread.new do
      news = eval(redis.lpop("url:to_analyze"))
      emotions = EmotionAnalyzer.on(url: news["link"])
      emotions.each do |emotion|
        case emotion["key"]
        when "好"
          news["hao"] = emotion["value"]
        when "乐"
          news["le"]  = emotion["value"]
        when "怒"
          news["nu"] = emotion["value"]
        when "哀"
          news["ai"] = emotion["value"]
        when "惧"
          news["ju"] = emotion["value"]
        when "恶"
          news["e"] = emotion["value"]
        when "惊"
          news["jing"] = emotion["value"]
        else
          puts "Error: no such category #{emotion['key']} in emotion"
        end
      end

      news = News.new(title: news["title"], 
                      description: news["description"],
                      guid: news["guid"],
                      pub_date: DateTime.parse(news["pubDate"]),
                      link: news["link"],
                      category: news["category"],
                      picture: news["picture"],
                      le: news['le'],
                      hao: news['hao'],
                      nu: news['nu'],
                      ai: news['ai'],
                      ju: news['ju'],
                      e: news['e'],
                      jing: news['jing'],
                     )
      if news.save
        print "+"
      else
        print "-"
      end
    end
  end

  threads.each { |t| t.join }
end

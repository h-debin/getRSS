#!/usr/bin/env ruby

require_relative '../config/environment'

def set_emotion_attr(news, emotions)
  if emotions.length > 0
    main_emotion = emotions[0]
    news["emotion_type"] = main_emotion["key"]
    news["main_emotion_value"] = main_emotion["value"].to_i
  end

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
  news
end

def get_image_from(url:)
  ImageGetter.largest(url:url)
end

redis = Redis.new(:port => 4568)
while redis.llen("url:to_analyze") != 0
  threads = []
  1.times do
    threads << Thread.new do
      news = eval(redis.lpop("url:to_analyze"))
      # ++
      # google news rss, item's link content google's suffix
      # ++
      news["link"] = news["link"].split("&url=")[1]
      puts "news link" + news["link"]
      
      emotions = EmotionAnalyzer.on(url: news["link"])
      news = set_emotion_attr(news, emotions)

      # ++
      # only save the news with image to redis
      # ++
      images = get_image_from(url: news["link"])
      if (images != "") && (images.include?"http")
        news["picture"] = images
        redis.lpush("news:processed", news)
      else
        puts images
        puts "images nil #{news["link"]}"
      end
    end
  end
  threads.each { |t| t.join }
end

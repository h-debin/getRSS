require 'active_record'
require 'date'

root = File.absolute_path("../", __FILE__)
database_root = File.join(root, "db")

Dir[File.join(root, "lib") + "/*"].each do |lib|
  puts lib
  require lib
end

if File.exists?(database_root + "./news.db") 
  raise "Exception: no news.db exist, please rake to create it first"
else
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => "#{database_root}/news.db")
  if !ActiveRecord::Base.connection.table_exists?("news")
    raise "Exception: no news table in news.db, please rake to create it first"
  end
end

redis = Redis.new(:port => 4568)

rss_list = JSON.parse(File.read('rss.json'))
["society", "technology", "sports", "entertainment", "uncategory"].each do |category|
  rss_list[category].each do |url|
    RSSParser.parse(url: url).each do |news|
      if !redis.sismember('url:visited', news)
        if redis.sadd('url:visited', news)
          puts "saved to redis done"
          redis.lpush('url:to_analyze', news)
        else
          puts "saved to redis failed"
        end
      else
          puts "already in"
      end
    end
  end
end
__END__
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
end

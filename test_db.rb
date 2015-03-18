require 'active_record'
require 'date'
require_relative 'model/news'
require_relative 'tokenizer/tokenizer'
require_relative 'emotion_analyzer/emotion_analyzer'
require_relative 'rss_parser/rss_parser'
require_relative 'readability/readability'

# ++
# creat table in database
# ++
def setup_news_table
  ActiveRecord::Schema.define do
    drop_table :news if table_exists? :users
    create_table :news do |table|
      table.column :title, :text
      table.column :description, :text
      table.column :guid, :text
      table.column :pub_date, :date_time
      table.column :link, :text
      table.column :category, :text
      table.column :picture, :text
      table.column :le, :text
      table.column :hao, :text
      table.column :nu, :text
      table.column :ai, :text
      table.column :ju, :text
      table.column :e, :text
      table.column :jing, :text
    end
  end
end

root = File.absolute_path(__FILE__)
database_root = File.join(File.dirname(root), "db")
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => File.join(database_root, "news.db"))
if !ActiveRecord::Base.connection.table_exists? 'news'
  setup_news_table
end

rss_list = JSON.parse(File.read('rss.json'))
["society", "technology", "sports", "entertainment", "uncategory"].each do |category|
  rss_list[category].each do |url|
    RSSParser.parse(url: url).each do |news|
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

      puts "---"
      puts news
      puts "---"
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
      if news.save!
        print "+"
      else
        puts "-"
      end
    end
  end
end

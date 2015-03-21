require_relative 'config/environment'

def create_db
  ActiveRecord::Schema.define do
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

def backup_db
  time = Time.now.strftime("%Y%m%d%H%M%S")
  if system("mv #{DB_ROOT}/news.db #{DB_ROOT}/#{time}_news.db")
    puts "db backup done"
  else
    puts "db backup failed"
  end
end

def install_gems
  `bundle install`
end

def install_nodejs_package
  `npm install node-readability`
end

def init_emotion_map
  puts `#{APP_ROOT}/emotion_map/xlsx_to_redis.rb`
end

def parse_rss
  puts `#{BIN_ROOT}/parse_rss.rb`
end

def process_urls
  puts `#{BIN_ROOT}/process_urls.rb`
end

def save_news
  redis = Redis.new(:port => 4568) 
  while redis.llen("news:processed") != 0
    news = eval(redis.lpop("news:processed"))
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

namespace :db do
  # ++
  desc "create a database file and create a table named 'news'"
  # ++
  task :create do
    create_db
  end

  # ++
  desc "back database"
  # ++
  task :backup do
    backup_db    
  end
end

namespace :news do
  desc "parse items from rss"
  task :parse_from_rss do
    parse_rss
  end

  desc "analyze items and save to redis cache"
  task :emotion_analyze do
    process_urls
  end

  desc "get news from redis cache and save to sqlite3 db"
  task :save_to_db do
    save_news
  end
end

# ++
desc "setup envirement"
# ++
task :init do
  install_gems
  install_nodejs_package

  init_emotion_map
end


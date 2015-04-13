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
      table.column :le, :integer
      table.column :hao, :integer
      table.column :nu, :integer
      table.column :ai, :integer
      table.column :ju, :integer
      table.column :e, :integer
      table.column :jing, :integer
      table.column :emotion_type, :text
      table.column :main_emotion_value, :text
      table.column :created_at, :Time
      table.column :updated_at, :Time
    end
  end
end

def backup_db
  time = Time.now.strftime("%Y%m%d%H%M%S")
  if system("mv #{DATABASE_ROOT}/news.db #{DATABASE_ROOT}/#{time}_news.db")
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

def delete_old_news
  News.where("created_at < ?", 2.days.ago).each do |item|
    if item.delete
      print '-'
    else
      puts "Cannot delete #{item}"
    end
  end
end

def save_news
  redis = Redis.new(:port => 4568)
  while redis.llen("news:processed") != 0
    news = eval(redis.lpop("news:processed"))
    begin
      news = News.new(title: news["title"],
                      description: news["description"],
                      guid: news["guid"],
                      pub_date: DateTime.parse(news["pubDate"]),
                      link: news["link"],
                      category: news["category"],
                      picture: news["picture"],
                      emotion_type: news["emotion_type"],
                      main_emotion_value: news["main_emotion_value"],
                      le: news['le'].to_i,
                      hao: news['hao'].to_i,
                      nu: news['nu'].to_i,
                      ai: news['ai'].to_i,
                      ju: news['ju'].to_i,
                      e: news['e'].to_i,
                      jing: news['jing'].to_i,
                      created_at: Time.now,
                      updated_at: Time.now
                         )
      if news.save
        print "+"
      else
        print "-"
      end
    rescue Exception => e
      puts "Exception: news save failed since #{e.to_s}"
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

  desc "delete old news from news table"
  task :delete_old do
    delete_old_news
  end
end

namespace :flow do
  desc "start whole flow"
  task :start do
    parse_rss
    process_urls
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

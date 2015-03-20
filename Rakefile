require 'active_record'

APP_ROOT = File.dirname(File.absolute_path('Gemfile'))
DB_ROOT = File.join(APP_ROOT, "db")
ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                        :database => "#{DB_ROOT}/news.db")

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

# ++
desc "setup envirement"
# ++
task :init do
  install_gems
  install_nodejs_package

  init_emotion_map
end

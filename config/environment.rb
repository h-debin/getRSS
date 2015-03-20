require 'active_record'
require 'redis'
require 'date'

APP_ROOT = File.absolute_path("../../", __FILE__)
DATABASE_ROOT = File.join(APP_ROOT, "db")
BIN_ROOT = File.join(APP_ROOT, "bin")
LIB_ROOT = File.join(APP_ROOT, "lib")

Dir[LIB_ROOT + "/*"].each do |lib|
  require lib
end

if File.exists?(DATABASE_ROOT + "./news.db") 
  raise "Exception: no news.db exist, please rake to create it first"
else
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", 
                                          :database => "#{DATABASE_ROOT}/news.db",
                                          :timeout => 10000)
  if !ActiveRecord::Base.connection.table_exists?("news")
    raise "Exception: no news table in news.db, please rake to create it first"
  end
end

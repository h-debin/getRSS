require 'redis'
require 'json'

redis = Redis.new(:port => 4568)
#hash = {"name" => "Eric", "agen" => "18" }
#redis.set("test", hash)
puts JSON.parse(redis.get("优秀").gsub("'",'"').gsub('=>',':'))

puts "abc".to_hash

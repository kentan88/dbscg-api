require "redis"

if Rails.env.production?
  puts "connecting to redis"
  REDIS = Redis.new(url: ENV['REDIS_URL'])
else
  REDIS = Redis.new
end

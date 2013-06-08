$:.unshift File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'acts_as_rrranking'
require 'factory_girl'
require 'factories'
require 'redis'

require 'coveralls'
Coveralls.wear!

REDIS_PORT = ENV['REDIS_PORT'] || 6379
REDIS_HOST = ENV['REDIS_HOST'] || 'localhost'

Redis.current = Redis.new(host: REDIS_HOST, port: REDIS_PORT)

require 'rack/test'
require 'support/redis_server'
RSpec.configure do |config|
  config.include Rack::Test::Methods
end

def create_redis_server_with password
  RedisServer.new(
    host: "localhost",
    port: 6380,
    password: password
  )
end

def configure_redis_server_lifecycles
  RSpec.configure do |config|
    config.before(:suite) do
      REDIS.start
    end

    config.after(:suite) do
      REDIS.stop
    end
  end
end

if ENV.has_key?('VCAP_SERVICES')
  puts "Not starting local redis-server, using the one defined in VCAP_SERVICES"
elsif ENV.has_key?('NO_AUTHENTICATION')
  REDIS = create_redis_server_with ""
  configure_redis_server_lifecycles
else
  REDIS = create_redis_server_with "p4ssw0rd"
  configure_redis_server_lifecycles
end

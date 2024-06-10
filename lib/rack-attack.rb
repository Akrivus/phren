require 'rack/attack'

class Rack::Attack
  throttle('req/ip', limit: 100, period: 30.minutes) do |req|
    req.ip
  end

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end
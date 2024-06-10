require 'rack/attack'

class Rack::Attack
  throttle('req/ip', limit: 5000, period: 1.hour) do |req|
    req.ip
  end

  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end
require 'dotenv/load' if ENV['RACK_ENV'] == 'development'
require 'active_support/all'
require 'scout_apm'
require 'rack/cors'

require './lib/rack-attack'
require './app'

ScoutApm::Rack.install!

use Rack::Attack

use Rack::Cors do
  allow do
    origins  '*'
    resource '*', methods: %i[get post options],
      headers: 'Authorization'
  end
end

run Sinatra::Application

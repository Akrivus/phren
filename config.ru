require 'dotenv/load' if ENV['RACK_ENV'] == 'development'

require 'active_support/all'

require 'scout_apm'

ScoutApm::Rack.install!

require './lib/rack-attack'

use Rack::Attack

require './app'

run Sinatra::Application

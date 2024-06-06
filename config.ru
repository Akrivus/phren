require "scout_apm"

ScoutApm::Rack.install!

require "rack/attack"

use Rack::Attack

require "./app"

run Sinatra::Application

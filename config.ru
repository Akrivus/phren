# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require_relative "app/services/sinatra_application"

use Rack::Attack

use SinatraApplication
run Rails.application

Rails.application.load_server

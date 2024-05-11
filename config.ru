# This file is used by Rack-based servers to start the application.

require_relative "config/environment"
require_relative "app/services/openai_engine"

use OpenAI::Engine

run Rails.application

Rails.application.load_server

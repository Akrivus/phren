require "sinatra"
require "sinatra/cors"

require_relative "sinatra/authentication"
require_relative "sinatra/openai"

set :allow_methods, "POST"
set :allow_origin, "*"
set :allow_headers, "content-type,authorization"
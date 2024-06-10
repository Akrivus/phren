require 'sinatra'

require_relative 'sinatra/authentication'
require_relative 'sinatra/openai'

set :allow_methods, 'OPTIONS,GET,POST'
set :allow_origin, '*'
set :allow_headers, 'content-type,authorization'

register Sinatra::Authentication
register Sinatra::OpenAI
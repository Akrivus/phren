require 'jwt'

require 'sinatra/base'

module Sinatra
  module AuthHelpers
    def token
      authorization = request.env['HTTP_AUTHORIZATION'][7..-1]
      token = JWT.decode(authorization, ENV['SECRET_KEY_BASE'], true, algorithm: 'HS256')
      token[0]
    end

    def authorized?
      token
    rescue JWT::DecodeError
      false
    end

    def authorize!
      halt 403, {
        "error" => {
          "message" => "Expired or invalid authorization token.",
          "type": "invalid_request_error",
          "param": nil,
          "code": "invalid_authorization_token"
        }}.to_json unless authorized?
    end
  end

  helpers AuthHelpers

  def self.registered(app)
    app.get '/auth' do
      content_type :json
      { 
        "token" => JWT.encode({
          exp: 1.hour.from_now.to_i,
          jti: SecureRandom.uuid,
        }, ENV['SECRET_KEY_BASE'], 'HS256')
      }.to_json
    end
  end
end

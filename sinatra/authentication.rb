require 'jwt'

require 'sinatra/base'

module Sinatra
  module Authentication
    module Helpers
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

    def self.registered(app)
      app.helpers Helpers

      app.get '/auth' do
        content_type :json
        { 
          "token" => JWT.encode({
            exp: Time.now.to_i + 3600,
            jti: SecureRandom.uuid,
          }, ENV['SECRET_KEY_BASE'], 'HS256')
        }.to_json
      end
    end
  end
end

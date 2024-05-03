class ApiController < ActionController::Base
  helper_method :current_user
  helper_method :set_current_user

  helper_method :json_error

  skip_before_action :verify_authenticity_token

  before_action :authenticate!

  def current_user
    @current_user ||= User.find_by(api_key: api_key)
  end

  def set_current_user(user)
    user.update(api_key: SecureRandom.hex)
    response.headers["x-api-key"] = user.api_key
    @current_user = user
  end

  def json_error message, status = :unprocessable_entity
    {
      json: { error: message },
      status: status
    }
  end

  private
    def api_key
      request.headers["x-api-key"]
    end

    def authenticate!
      render json_error("Missing or invalid API key.", :unauthorized) if current_user.nil?
    end
end

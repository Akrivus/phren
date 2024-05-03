class Api::V1::ApiKeyController < ApiController
  skip_before_action :authenticate!, only: %i[auth]

  def auth
    user = User.find(params[:id])
    if user && user.authenticate(params[:password])
      set_current_user(user)
      render json: { api_key: user.api_key }
    elsif user.nil?
      render json_error('Invalid user ID.', :unauthorized)
    else
      render json_error('Incorrect password.', :unauthorized)
    end
  end
end

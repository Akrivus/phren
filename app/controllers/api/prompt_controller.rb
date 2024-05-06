class Api::PromptController < BaseApiController
  before_action :set_prompts

  skip_before_action :authenticate!, only: %i[auth]

  def show
    @prompt = @prompts.find(params[:id])
  end

  def auth
    user = User.find(params[:user_id])
    if user && user.authenticate(params[:password])
      set_current_user(user)
      render json: { api_key: user.api_key }
    elsif user.nil?
      render json_error('Invalid user ID.', :unauthorized)
    else
      render json_error('Incorrect password.', :unauthorized)
    end
  end

  private

    def set_prompts
      @prompts = current_user.prompts.all
    end
end
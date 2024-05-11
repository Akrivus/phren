class ApiController < ActionController::Base
  before_action :set_prompt, only: %i[create]
  before_action :set_chat, only: %i[show message]
  before_action :set_message, only: %i[message]

  skip_before_action :verify_authenticity_token

  rescue_from ActiveRecord::RecordInvalid, ActionController::ParameterMissing do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { error: e.message }, status: :not_found
  end

  def show

  end

  def create
    @chat = @prompt.chats.create(params.permit(:context))
    @token = JWT.encode({
      exp: 1.hour.from_now.to_i,
      cid: @chat.id,
      uid: @prompt.id
    }, ENV['SECRET_KEY_BASE'], 'HS256')
  end

  def message
    @message.update(content: @message.content + message_params[:content])
    @message.audio_files.attach(message_params[:audio_files])
  end

  private

    def message_params
      params.permit(:content, :role, :audio_files)
    end

    def set_message
      role = message_params[:role] || 'user'
      @message = @chat.messages.last
      return if @message.role == role
      @message = @chat.messages.create(role: role, content: '')
    end

    def set_chat
      @chat = Chat.find(params.require(:id))
    end

    def set_prompt
      @prompt = Prompt.find(params.require(:prompt_id))
    end
end

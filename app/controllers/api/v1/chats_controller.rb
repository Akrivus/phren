class Api::V1::ChatsController < ApiController
  include OpenAIClient

  before_action :set_person
  before_action :set_chat, only: %i[show update destroy]

  skip_before_action :authenticate!

  def create
    @chat = @person.chats.create! prompt: @person.prompt
    render json: @chat, status: :created
  end

  def show
    render json: @chat
  end

  def update
    transcribe_message_audio if transcribe_message_audio_params.present?
    @chat.messages.create! message_params
    parameters = @person.to_parameters(@chat.messages_to_map)
    message = @chat.messages.create(role: 'assistant')

    event_stream if streaming?

    if streaming? && tts?
      chat_tts(parameters, @person.voice, message) do |text, audio|
        event_stream.write({ content: text, audio_files: [{ url: audio.url }] })
      end
    elsif streaming?
      chat(parameters, message) do |text|
        event_stream.write({ content: text })
      end
    elsif tts?
      text, audio = chat_tts(parameters, message)
      render json: { content: text, audio_files: [{ url: audio.url }] }
    else
      text = chat(parameters, message)
      render json: { content: text }
    end
  end

  def destroy
    @chat.destroy!
    render json: { status: :ok }
  end

  private
    def set_chat
      @chat = @person.chats.find(params[:id])
    end

    def set_person
      @person = Person.find(params[:person_id])
    end
  
    def message_params
      params.require(:message).permit(:content)
    end

    def streaming?
      params[:stream].present?
    end

    def tts?
      params[:tts].present?
    end

    def event_stream
      response.headers['Content-Type'] = 'text/event-stream'
      @sse ||= ActionController::Live::SSE.new(response.stream, retry: 300, event: 'data')
    end

    def transcribe_message_audio_params
      params.require(:message_audio).permit(:file, :prompt) if params[:message_audio].present?
    end

    def transcribe_message_audio
      message_params[:content] = transcribe(
        transcribe_message_audio_params[:file],
        transcribe_message_audio_params[:prompt])
    end
end

class Api::ChatController < BaseApiController
  before_action :set_chat, only: %i[show transcriptions speech]
  before_action :set_message, only: %i[transcriptions]
  before_action :set_latest_message, only: %i[speech]

  skip_before_action :authenticate!

  def show

  end

  def create
    @chat = prompt.chats.create params.permit(:context)
  end

  def speech
    speech = openai_client.audio.speech(parameters: { model: 'tts-1', voice: @chat.prompt.voice, input: speech_params[:input], response_format: speech_params[:response_format] })
    
    @message.update(content: @message.content + speech_params[:input])
    @message.audio_files.attach(io: StringIO.new(speech), filename: "speech.#{speech_params[:response_format]}", content_type: "audio/#{speech_params[:response_format]}")
    send_data speech
  rescue Faraday::ClientError => e
    render json: e.response.body, status: e.response.status
  end

  def transcriptions
    transcription = openai_client.audio.transcribe(parameters: { model: 'whisper-1', prompt: transcription_params[:prompt], file: transcription_params[:file] })
    
    @message.update(content: transcription.dig('text'))
    @message.audio_files.attach(transcription_params[:file])
    render json: transcription
  rescue Faraday::ClientError => e
    render json: e.response.body, status: e.response.status
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def set_message role = 'user'
      @message = @chat.messages.create(role: role, content: '')
    end

    def set_latest_message
      @message = @chat.messages.last
      return if @message.role == 'assistant'
      set_message 'assistant'
    end

    def transcription_params
      params.require(:file)
      params.permit(:file, :prompt)
    end

    def speech_params
      params[:response_format] ||= 'wav'
      params.require(:input)
      params.permit(:input, :response_format)
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
end

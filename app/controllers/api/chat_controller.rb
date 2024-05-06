class Api::ChatController < BaseApiController
  before_action :set_chat, only: %i[show transcriptions speech]
  before_action :set_message, only: %i[transcriptions speech]

  skip_before_action :authenticate!

  def show

  end

  def create
    @chat = prompt.chats.create(voice: @prompt.voice, name: params[:name])
  end

  def speech
    speech = openai_client.audio.speech(parameters:
      { model: 'tts-1', voice: @chat.voice,
        input: speech_params[:input] })
    @message.content = speech_params[:input]
    @message.audio_files.attach(io: StringIO.new(speech),
      filename: 'speech.wav', content_type: 'audio/wav')
    send_data speech
  end

  def transcriptions
    transcription = openai_client.audio.transcribe(parameters:
      { model: 'whisper-1',
        prompt: transcription_params[:prompt],
        file: transcription_params[:file] })
    @message.content = transcription.dig('text')
    @message.audio_files.attach(transcription_params[:file])
    render json: transcription
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def set_message
      @message = @chat.messages.new
    end

    def set_prompt
      @prompt = current_user.prompts.find(params[:prompt_id])
    end

    def transcription_params
      return { file: params[:file], prompt: params[:prompt] }
    end

    def speech_params
      return { input: params[:input] }
    end

    def openai_client
      @openai_client ||= OpenAI::Client.new
    end
end

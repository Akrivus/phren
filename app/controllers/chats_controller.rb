class ChatsController < ApplicationController
  before_action :set_chats, only: %i[ index new create ]
  before_action :set_chat, only: %i[ show edit update destroy ]

  # GET /people/:person_id/chats
  def index
    @chats = @chats.all
  end

  # GET /people/:person_id/chats/:id 
  def show

  end

  # POST /people/:person_id/chats
  def create
    @chat = @chats.new(prompt: @person.prompt)
  end

  # PUT /people/:person_id/chats/:id 
  def update
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: 'data')

    params[:message] = OpenAIClient::transcribe(params[:message_audio], params[:audio_context]) if params[:message_audio].present?
    message = @chat.add_message(params[:message])
    message.audio_files.attach(params[:message_audio]) if params[:message_audio].present?

    message = @chat.add_message(text, 'assistant')
    count = 0
    text = OpenAIClient::chat_tts(message, @person.parameters) do |speech|
      io = StringIO.new(speech)
      message.audio_files.attach(io: io,
        filename: "#{message.id}.#{count}.wav",
        content_type: 'audio/wav')
      count += 1
      sse.write({ url: speech.url })
    end
  ensure
    sse.close
  end

  # DELETE /people/:person_id/chats/:id 
  def destroy
    @chat.destroy!

    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_chats
      @chats = Chat.where(person_id: params[:person_id])
      @person = Person.find(params[:person_id])
    end

    def set_chat
      @chat = Chat.find(params[:id])
    end
end

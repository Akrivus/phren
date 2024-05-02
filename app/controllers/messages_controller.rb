class MessagesController < ApplicationController
  before_action :set_messages, only: %i[ index new create ]
  before_action :set_message, only: %i[ show edit update destroy ]

  # GET /friends/:friend_id/chats/:chat_id/messages
  def index
    @messages = @messages.all
  end

  # GET /friends/:friend_id/chats/:chat_id/messages/:id
  def show
  end

  # GET /friends/:friend_id/chats/:chat_id/messages/new
  def new
    @message = Message.new
  end

  # GET /friends/:friend_id/chats/:chat_id/messages/:id/edit
  def edit
  end

  # POST /friends/:friend_id/chats/:chat_id/messages
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to message_url(@message), notice: "Message was successfully created." }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /friends/:friend_id/chats/:chat_id/messages/:id
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to message_url(@message), notice: "Message was successfully updated." }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /friends/:friend_id/chats/:chat_id/messages/:id
  def destroy
    @message.destroy!

    respond_to do |format|
      format.html { redirect_to messages_url, notice: "Message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_messages
      @messages = Message.where(chat_id: params[:chat_id])
    end

    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:content, :role)
    end
end

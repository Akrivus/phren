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

  # GET /people/:person_id/chats/new
  def new
    @chat = @chats.new
  end

  # GET /people/:person_id/chats/:id /edit
  def edit

  end

  # POST /people/:person_id/chats
  def create
    @chat = @chats.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/:person_id/chats/:id 
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
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
    end

    def set_chat
      @chat = Chat.find(params[:id])
    end

    def chat_params
      params.require(:chat).permit(:summary, :active)
    end
end

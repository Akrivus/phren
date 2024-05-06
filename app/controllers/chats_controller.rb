class ChatsController < ApplicationController
  before_action :set_chats, only: %i[ index new create ]
  before_action :set_chat, only: %i[ show edit update destroy ]

  # GET /prompts/:prompt_id/chats
  def index
    @chats = @chats.all
  end

  # GET /prompts/:prompt_id/chats/:id 
  def show

  end

  # POST /prompts/:prompt_id/chats
  def create
    @chat = @chats.new(prompt: @prompt.prompt)
  end

  # PUT /prompts/:prompt_id/chats/:id 
  def update
    
  end

  # DELETE /prompts/:prompt_id/chats/:id 
  def destroy
    
  end

  private
    def set_chats
      @chats = Chat.where(prompt_id: params[:prompt_id])
      @prompt = Prompt.find(params[:prompt_id])
    end

    def set_chat
      @chat = Chat.find(params[:id])
    end
end

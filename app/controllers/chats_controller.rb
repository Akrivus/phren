class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show destroy ]

  # GET /prompts/:prompt_id/chats
  def index
    @chats = prompt.chats
  end

  # GET /prompts/:prompt_id/chats/:id 
  def show

  end

  # GET /prompts/:prompt_id/chats/new
  def new
    
  end

  # DELETE /prompts/:prompt_id/chats/:id 
  def destroy
    @chat.destroy!

    redirect_to prompt_chats_url(prompt), notice: "Chat was successfully destroyed."
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
    end
end

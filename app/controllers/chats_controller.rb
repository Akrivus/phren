class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show destroy ]
  before_action :prompt

  skip_before_action :require_login, only: %i[new]

  # GET /prompts/:prompt_id/chats
  def index
    @chats = prompt.chats.in_order
  end

  # GET /prompts/:prompt_id/chats/:id 
  def show

  end

  # GET /prompts/:prompt_id/chats/new
  def new
    render :new, layout: false
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

    def prompt
      @prompt ||= Prompt.find(params[:prompt_id])
    end
end

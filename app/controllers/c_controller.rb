class CController < ApplicationController
  skip_before_action :require_login

  def show
    @prompt = Prompt.find_by(slug: params[:slug])
    render 'chats/new', layout: false unless @prompt.nil?
  end
end
class CController < ApplicationController
  skip_before_action :require_login

  def show
    @prompt = Prompt.find_by(slug: params.require(:c))
    render :show, layout: false
  end
end

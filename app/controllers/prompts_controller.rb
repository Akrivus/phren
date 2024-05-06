class PromptsController < ApplicationController
  before_action :set_prompts, only: %i[ index new create ]
  before_action :set_prompt, only: %i[ show edit update destroy ]

  # GET /prompts
  def index
    @prompts = @prompts.all
  end

  # GET /prompts/:id
  def show
    
  end

  # GET /prompts/new
  def new
    @prompt = @prompts.new
  end

  # GET /prompts/:id/edit
  def edit

  end

  # POST /prompts
  def create
    @prompt = @prompts.new(prompt_params)

    if @prompt.save
      redirect_to prompt_url(@prompt), notice: "Prompt was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prompts/:id
  def update
    if @prompt.update(prompt_params)
      redirect_to prompt_url(@prompt), notice: "Prompt was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /prompts/:id
  def destroy
    @prompt.destroy!
    redirect_to prompts_url, notice: "Prompt was successfully destroyed."
  end

  private
    def set_prompts
      @prompts = current_user.prompts
    end

    def set_prompt
      @prompt = Prompt.find(params[:id])
    end

    def prompt_params
      params.require(:prompt).permit(:id, :name, :person_prompt, :system_prompt, :avatar)
    end
end

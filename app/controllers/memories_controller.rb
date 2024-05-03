class MemoriesController < ApplicationController
  before_action :set_memories, only: %i[ index new create ]
  before_action :set_memory, only: %i[ show edit update destroy ]

  # GET /people/:person_id/memories
  def index
    @memories = @memories.all
  end

  # GET /people/:person_id/memories/:id
  def show
  end

  # GET /people/:person_id/memories/new
  def new
    @memory = @memories.new
  end

  # GET /people/:person_id/memories/:id/edit
  def edit
  end

  # POST /people/:person_id/memories
  def create
    @memory = @memories.new(memory_params)

    respond_to do |format|
      if @memory.save
        format.html { redirect_to memory_url(@memory), notice: "Memory was successfully created." }
        format.json { render :show, status: :created, location: @memory }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @memory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/:person_id/memories/:id
  def update
    respond_to do |format|
      if @memory.update(memory_params)
        format.html { redirect_to memory_url(@memory), notice: "Memory was successfully updated." }
        format.json { render :show, status: :ok, location: @memory }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @memory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/:person_id/memories/:id
  def destroy
    @memory.destroy!

    respond_to do |format|
      format.html { redirect_to memories_url, notice: "Memory was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_memories
      @memories = Memory.where(person_id: params[:person_id])
    end

    def set_memory
      @memory = Memory.find(params[:id])
    end

    def memory_params
      params.require(:memory).permit(:content)
    end
end

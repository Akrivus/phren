class DocumentsController < ApplicationController
  before_action :set_documents, only: %i[ index new create ]
  before_action :set_document, only: %i[ show edit update destroy ]

  # GET /people/:person_id/documents
  def index
    @documents = @documents.all
  end

  # GET /people/:person_id/documents/:id 
  def show
  end

  # GET /people/:person_id/documents/new
  def new
    @document = @documents.new
  end

  # GET /people/:person_id/documents/:id /edit
  def edit
  end

  # POST /people/:person_id/documents
  def create
    @document = @documents.new(document_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to document_url(@document), notice: "Document was successfully created." }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /people/:person_id/documents/:id 
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to document_url(@document), notice: "Document was successfully updated." }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/:person_id/documents/:id 
  def destroy
    @document.destroy!

    respond_to do |format|
      format.html { redirect_to documents_url, notice: "Document was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_documents
      @documents = Document.where(person_id: params[:person_id])
    end

    def set_document
      @document = Document.find(params[:id])
    end

    def document_params
      params.require(:document).permit(:name, :summary, :file)
    end
end

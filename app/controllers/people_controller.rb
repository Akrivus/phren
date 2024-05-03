class PeopleController < ApplicationController
  before_action :set_people, only: %i[ index new create ]
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /people
  def index
    @people = @people.all
  end

  # GET /people/:id
  def show
    
  end

  # GET /people/new
  def new
    @person = @people.new
  end

  # GET /people/:id/edit
  def edit

  end

  # POST /people
  def create
    @person = @people.new(person_params)

    respond_to do |format|
      if @person.save
        format.html { redirect_to person_url(@person), notice: "person was successfully created." }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/:id
  def update
    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to person_url(@person), notice: "person was successfully updated." }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/:id
  def destroy
    @person.destroy!

    respond_to do |format|
      format.html { redirect_to people_url, notice: "person was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_people
      @people = current_user.people
    end

    def set_person
      @person = person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:name, :person_prompt, :system_prompt)
    end
end

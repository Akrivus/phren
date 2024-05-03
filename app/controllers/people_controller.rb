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

    if @person.save
      redirect_to person_url(@person), notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/:id
  def update
    if @person.update(person_params)
      redirect_to person_url(@person), notice: "Person was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/:id
  def destroy
    @person.destroy!
    redirect_to people_url, notice: "Person was successfully destroyed."
  end

  private
    def set_people
      @people = current_user.people
    end

    def set_person
      @person = Person.find(params[:id])
    end

    def person_params
      params.require(:person).permit(:id, :name, :person_prompt, :system_prompt, :avatar)
    end
end

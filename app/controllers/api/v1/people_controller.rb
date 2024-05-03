class Api::V1::PeopleController < ApiController
  before_action :set_people
  before_action :set_person, only: %i[show]

  def index
    render json: @people
  end

  def show
    render json: @person
  end

  private
    def set_people
      @people = current_user.people.all
    end

    def set_person
      @person = @people.find(params[:id])
    end
end
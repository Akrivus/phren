class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  skip_before_action :require_login, only: %i[ new create auth login ]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/:id
  def show

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit

  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/:id
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/:id
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /users/auth
  def auth
    @user = User.find_by(username: params[:username])
    logged_in = @user && @user.authenticate(params[:password])
    set_current_user(@user) if logged_in

    respond_to do |format|
      if logged_in?
        format.html { redirect_to people_url, notice: "Welcome!" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to login_url, notice: "Invalid username or password" }
        format.json { render json: { error: "Invalid username or password" }, status: :unprocessable_entity }
      end
    end
  end

  # GET /login
  def login

  end

  # GET /logout
  def logout
    set_current_user(nil)
    redirect_to login_url, notice: "Logged out"
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end

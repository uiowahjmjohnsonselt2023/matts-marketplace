class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # This is what you add to your controllers require authentication. It is actually so useful.
  before_action :authenticate_user!, only: %i[ show edit update destroy index]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
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

  # PATCH/PUT /users/1 or /users/1.json
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

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def review
    @reviewed_user_id = params[:id]
    @reviewee = User.find(@reviewed_user_id)
    if params["review"]
      review = review_params


      if @reviewee.reviewee_reviews.pluck(:reviewer_id).include? current_user.id
        redirect_to user_path(@reviewed_user_id), :notice => "You can only review a seller once!", allow_other_host: true and return
      end

      Review.create(
        reviewer: current_user,
        reviewee: @reviewee,
        title: review["title"],
        content: review["content"],
        rating: review["rating"].to_i
      )

      redirect_to user_path(@reviewed_user_id)
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :city, :country, :password_digest, :username, :email)
    end

  def review_params
    params.require(:review).permit(:rating, :title, :content)
  end
end

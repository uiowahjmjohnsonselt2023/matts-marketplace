class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy update_ban ]

  # This is what you add to your controllers require authentication. It is actually so useful.
  before_action :authenticate_user!, only: %i[ show edit update destroy index]
  before_action :require_admin, only: %i[ edit update destroy update_ban ]
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
      # check empty field
      if has_blank_field?
        redirect_to edit_user_path(@user)
        return
      end
      if @user.update(user_params)
        format.html { redirect_to admin_manage_users_url, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: "User update failed."  }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_ban
    if @user == current_user
      flash[:alert] = "You cannot ban yourself."
      redirect_to admin_manage_users_path
      return
    elsif @user.banned
      if @user.update(banned: false)
        flash[:notice] = "User has been banned successfully."
      else
        flash[:alert] = "Unable to ban the user."
      end
    else
      if @user.update(banned: true)
        flash[:notice] = "User has been banned successfully."
      else
        flash[:alert] = "Unable to ban the user."
      end
    end

    redirect_to admin_manage_users_path
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
      rating = review["rating"].to_f

      if @reviewee.reviewee_reviews.pluck(:reviewer_id).include? current_user.id
        redirect_to user_path(@reviewed_user_id), :notice => "You can only review a seller once!", allow_other_host: true and return
      end

      Review.create(
        reviewer: current_user,
        reviewee: @reviewee,
        title: review["title"],
        content: review["content"],
        rating: rating
      )

      # Update reviewee rating
      if @reviewee.rating
        @reviewee.rating = @reviewee.reviewee_reviews.pluck(:rating).sum / @reviewee.reviewee_reviews.length
      else
        @reviewee.rating = rating
      end

      @reviewee.save

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
      params.require(:user).permit(:first_name, :last_name, :city, :country, :password_digest, :username, :email, :balance, :rating, :admin, :banned)
    end

    def review_params
      params.require(:review).permit(:rating, :title, :content)
    end

    def require_admin
      unless current_user&.admin?
        redirect_to root_path, notice: "You must be an admin to access this page."
      end
    end

  # check if any field is blank and set alert
  def has_blank_field?
    blank_fields = user_params.select { |_, value| value.blank? }.keys
    unless blank_fields.empty?
      flash[:alert] = "The following fields are blank: #{blank_fields.join(', ')}"
    end
    !blank_fields.empty?
  end

end

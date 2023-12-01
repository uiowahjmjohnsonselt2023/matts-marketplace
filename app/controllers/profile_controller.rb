class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update ]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to profile_show_url, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: "User update failed." }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def wishlist
    items = current_user.wishlist_items
    # Make 2d array of items separated by category
    @wishlist_items = items.group_by(&:category)
    # Sort by number of items in each category while keeping the hash structure
    @wishlist_items = @wishlist_items.sort_by { |category, items| items.length }.reverse.to_h
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :country, :city)
  end
end

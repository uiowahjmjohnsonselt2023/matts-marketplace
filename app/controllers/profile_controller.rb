class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ show edit update ]

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      # check empty field
      if has_blank_field?
        redirect_to profile_edit_url
        return
      end

      if @user.update(user_params)
        format.html { redirect_to profile_show_url, notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: "Profile update failed." }
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

  def balance
    @user = current_user
    render 'profile/balance'
  end

  def add_balance
  @user = current_user
  @user.balance += params[:balance].to_d
  if @user.save
    flash[:notice] = "Balance updated successfully."
  else
    flash[:alert] = "Balance update failed."
  end
  redirect_to profile_balance_url
end

  def withdraw_balance
  @user = current_user
  withdrawal_amount = params[:balance].to_d
  if withdrawal_amount > @user.balance
    flash[:alert] = "Withdrawal amount exceeds current balance."
  else
    @user.balance -= withdrawal_amount
    if @user.save
      flash[:notice] = "Balance updated successfully."
    else
      flash[:alert] = "Failed to update balance."
    end
  end
  redirect_to profile_balance_url
end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :country, :city, :email)
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

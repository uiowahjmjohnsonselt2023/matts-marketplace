class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :set_sidebar
  before_action :check_banned_user, except: [:index, :destroy]
  before_action :check_required_fields, except: [:edit, :update, :destroy]

  # Default methods to prevent error for before_action :check_required_fields
  def index
  end


  def edit
  end

  def update
  end

  def destroy
  end

  private
  # redirect the user to update profile if first logged_in
  def check_required_fields
    required_fields = [:first_name, :last_name, :country, :city, :email]

    if user_signed_in? && required_fields.any? { |field| current_user[field].nil? }
      flash[:alert] = "Please fill in all required fields before using the application."
      redirect_to profile_edit_url
    end
  end

  # redirect the user to update profile if first logged_in
  def check_banned_user
    if user_signed_in? && current_user.banned
      flash[:alert] = "You are banned from using the app. Please contact admin."
      redirect_to home_index_url
    end
  end

  # def set_sidebar
  #   @sidebar_present = ["profile"].include?(params[:controller])
  # end
end

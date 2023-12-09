class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :set_sidebar
  before_action :check_banned_user, except: [:index, :destroy]

  def index
  end

  def destroy
  end

  private
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

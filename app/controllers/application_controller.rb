class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_sidebar

  private
  def set_sidebar
    @sidebar_present = ["profile"].include?(params[:controller])
  end
end

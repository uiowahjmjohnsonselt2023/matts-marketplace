# frozen_string_literal: true

class AuthenticationController < ActionController::Base
  before_action :authenticate_user!

  private

  def authenticate_user!
    unless user_signed_in?
      flash[:alert] = "You must be logged in to use this feature"
      redirect_to new_user_session_path
    end
  end
end

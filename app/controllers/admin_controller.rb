class AdminController < ApplicationController
  before_action :require_admin

  def manage_users

  end

  private
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, notice: "You must be an admin to access this page."
    end
  end
end

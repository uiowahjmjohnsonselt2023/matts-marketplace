class AdminController < ApplicationController
  before_action :require_admin

  def manage_users
    @users = User.all
  end

  def manage_purchases
    @purchases = Purchase.all
  end

  def manage_items
    @items = Item.all
  end

  def analytics
    # total analytics
    @purchases = Purchase.includes(:item).all
    @total_transactions = @purchases.count
    @total_amount = @purchases.joins(:item).sum("items.price")
    @total_users = User.count

    # last week analytics
    @start_date = 7.days.ago.beginning_of_day
    @last_week_purchases = @purchases.where(created_at: @start_date..Time.current)
    @last_week_transactions = @last_week_purchases.count
    @last_week_amount = @last_week_purchases.joins(:item).sum("items.price")
    @last_week_users = User.where(created_at: @start_date..Time.current).count

  end

  private
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, notice: "You must be an admin to access this page."
    end
  end
end

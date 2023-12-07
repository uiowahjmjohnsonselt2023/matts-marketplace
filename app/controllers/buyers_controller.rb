class BuyersController < ApplicationController
  before_action :authenticate_user!, only: [:checkout]
  def index
    @items = Item.where(for_sale: true)
  end

  def show
    @item = Item.find(params[:id])
    render layout: 'application'
  end
  def checkout
    @item = Item.where(for_sale: true).find(params[:id])
    @user = current_user
    @purchase = Purchase.new()
    render layout: 'application'
  end
end

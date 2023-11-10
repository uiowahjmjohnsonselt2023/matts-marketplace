class BuyersController < ApplicationController
  def index
    @items = Item.where(for_sale: true)
  end

  def show
    @item = Item.where(for_sale: true).find(params[:id])
  end
end

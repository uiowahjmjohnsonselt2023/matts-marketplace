class BuyersController < ApplicationController
  def index
    @items = Item.where(for_sale: true)
  end

  def show
    @item = Item.where(for_sale: true).find(params[:id])
    render layout: 'application'
  end

  def checkout
    @item = Item.where(for_sale: true).find(params[:id])
    @purchase = Purchase.new()
    render layout: 'application'
  end
end

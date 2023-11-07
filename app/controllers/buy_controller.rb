class BuyController < ApplicationController
  def index
    @items = Item.all
  end
end

class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
  end

  def update
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :price, :image_url)
  end
end

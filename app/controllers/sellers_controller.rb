class SellersController < AuthenticationController
  def index
    @seller = current_user
    @seller_items = @seller.items
  end

  def new_item
    @item = Item.new
  end

end

class SellersController < AuthenticationController
  def index
    @seller = current_user
    @seller_items = @seller.items
    render layout: 'application'
  end

  def new_item
    @item = Item.new
    render layout: 'application'
  end

end

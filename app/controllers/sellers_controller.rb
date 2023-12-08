class SellersController < AuthenticationController
  def index
    @seller = current_user
    @seller_items = @seller.items
    @seller_for_sale = @seller_items.where(for_sale: true)
    @seller_sold = @seller_items.where(for_sale: false ,sold: false)
    @seller_not_for_sale = @seller_items.where(for_sale: false, sold: true)
    render layout: 'application'
  end

  def new_item
    @item = Item.new
    render layout: 'application'
  end

end

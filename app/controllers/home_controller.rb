class HomeController < ApplicationController
  def index
    @featured_items = Item.where('for_sale')
  end
end

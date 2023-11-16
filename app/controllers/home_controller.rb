class HomeController < ApplicationController
  def index
    @featured_items = Item.where('for_sale')
    @all_categories = Category.all
  end
end

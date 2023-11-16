class HomeController < ApplicationController
  def index
    @featured_items = Item.where('for_sale AND featured').order(featured_amount_paid: :desc)
    @all_categories = Category.all
  end
end

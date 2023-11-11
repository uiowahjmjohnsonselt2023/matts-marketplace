class Item < ApplicationRecord
  belongs_to :user

  def self.search (terms, categories, price_range)
    #byebug
    price_low = 0
    price_high = 1000000
    if !price_range.nil? && !price_range.empty?
      if price_range =~ />/
        price_range = price_range.split("$")
        price_low = price_range[1].to_i
      else
        price_range = price_range.split("-")
        price_low = price_range[0].to_i
        price_high = price_range[1].to_i
      end
    end
    items = Item.where("price >= ? AND price <= ?", price_low, price_high)
    if !categories.nil? && !categories.empty?
      categories.each do |category|
        items = items.and(Item.where("category == (?)", category)) unless category.empty?
      end
    end
    if !terms.nil? && !terms.empty?
      terms = terms.split(" ")
      terms.each do |term|
        items = items.and(Item.where("description LIKE (?)", "%#{term}%"))
      end
    end
    items
  end
end

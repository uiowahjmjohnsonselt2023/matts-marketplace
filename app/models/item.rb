class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :purchase

  def self.search(terms, categories, price_range)
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
        category_object = Category.where("name == (?)", Item.sanitize_sql_like(category)).first
        # Not sure how important the sanitize_sql_like is here, but it's probably a good idea
        items = items.and(category_object.items) unless category.empty?
      end
    end
    if !terms.nil? && !terms.empty?
      terms = terms.split(" ")
      terms.each do |term|
        # Very important to sanitize the search term to prevent SQL injection attacks!
        items = items.and(Item.where("description LIKE (?)", "%#{Item.sanitize_sql_like(term)}%"))
      end
    end
    items
  end
end

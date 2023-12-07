class Item < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_one :purchase
  has_many :chat # I am not sure if we want a has_many or has_one relationship here
  has_and_belongs_to_many :wishlist_users, class_name: "User"
  validates :price, :description, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :featured_amount_paid, presence: true, if: :featured?
  validates :featured_amount_paid, numericality: { greater_than: 0 }, if: :featured?

  def self.search(terms, categories, price_range)
    self.search_explicit(terms, categories, price_range, true)
  end

  def self.search_explicit(terms, categories, price_range, for_sale)
    price_low = 0
    price_high = 1000000
    if !price_range.nil? && !price_range.empty?
      if price_range =~ />/
        price_range = price_range.split("$")
        price_low = price_range[1].to_i
      else
        price_range = price_range.sub("$", "").split("-")
        price_low = price_range[0].to_i
        price_high = price_range[1].to_i
      end
    end
    items = 0
    if for_sale
      items = Item.where("price >= ? AND price <= ? AND for_sale", price_low, price_high)
    else
      items = Item.where("price >= ? AND price <= ? AND NOT for_sale", price_low, price_high)
    end
    if !categories.nil? && !categories.empty?
      categories.each do |category|
          category_object = Category.where("name = (?)", category).first
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

  def featured?
    featured.present? && featured == true
  end

end

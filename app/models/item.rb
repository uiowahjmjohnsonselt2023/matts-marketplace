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

  def self.search(terms, categories, price_range, rating_range)
    self.search_explicit(terms, categories, price_range, rating_range, true)
  end

  def self.search_explicit(terms, categories, price_range, rating_range, for_sale)
    price_low = 0
    price_high = Item.all.pluck(:price).max
    if !price_range.nil? && !price_range.empty? && price_range != "$-"
      if price_range =~ />/
        price_range = price_range.split("$")
        price_low = price_range[1].to_i
      else
        price_range = price_range.sub("$", "").split("-")
        price_low = price_range[0].to_i
        price_high = price_range[1].to_i
      end
    end


    rating_low = 0
    rating_high = User.all.pluck(:rating).compact.max
    if !rating_range.nil? && !rating_range.empty? && rating_range != "-"
      if rating_range =~ />/
        rating_range = rating_range.split("$")
        rating_low = rating_range[1].to_i
      else
        rating_range = rating_range.sub("$", "").split("-")
        rating_low = rating_range[0].to_i
        rating_high = rating_range[1] ? rating_range[1].to_i : 5
      end
    end

    items = 0
    if for_sale
      users = User.where("(rating >= ? AND rating <= ?) OR rating IS NULL", rating_low, rating_high).pluck(:id)
      items = Item.where("price >= ? AND price <= ? AND for_sale AND user_id in (?)", price_low, price_high, users)
    else
      users = User.where("(rating >= ? AND rating <= ?) OR rating IS NULL", rating_low, rating_high).pluck(:id)
      items = Item.where("price >= ? AND price <= ? AND NOT for_sale AND user_id in (?)", price_low, price_high, users)
    end


    if (!categories.nil? && !categories.empty?) && (!categories[0].nil? && !categories[0].empty?)
      category_items = []
      categories[0].compact.each do |category|
        category_items = category_items | Category.where(name: category).first.items
      end

      items = items & category_items
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

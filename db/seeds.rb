# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


["Clothing", "Electronics", "Toys", "Books", "Home"].each do |category_name|
  Category.create(name: category_name)
end

10.times do |i|
  User.create!(
    first_name: %w[Sergio Dylan Haruko Mingi Matthew].sample,
    last_name: %w[Martelo Laurianti Okada Lee Speranza].sample,
    city: "City#{i}",
    country: "Country#{i}",
    username: "user#{i + 1}", # Start at user1 to avoid user0
    email: "user#{i + 1}@example.com",
    password: "somepassword#{i + 1}",
    rating: 5 * rand(),
  )
end

users = User.all
categories = Category.all

50.times do |i|
  Item.create!(
    price: (rand * 100).round(2),
    description: "Item description #{i}",
    image_url: "http://example.com/image#{i}.png",
    for_sale: [true, false].sample,
    featured: [true, false].sample,
    featured_amount_paid: rand(1000),
    category: categories.sample,
    user: users.sample # This will randomly assign a user to each item
  )
end

5.times do ||
  Chat.create(
    buyer: users.sample,
    seller: users.sample
  )
end


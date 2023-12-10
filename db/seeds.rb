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
    password: "testtest",
    rating: nil,
  )
end

User.create!(
  first_name: "Hans",
  last_name: "Johnson",
  city: "Iowa City",
  country: "USA",
  username: "hjmjohnson",
  email: "hans@uiowa.edu",
  password: "adminpassword",
  rating: 5,
  admin: true
  )

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

items = Item.all
5.times do ||
  Chat.create(
    buyer: users.sample,
    seller: users.sample,
    item: items.sample,
  )
end


30.times do ||
  reviewee = users.sample
  reviewer = users.sample
  rating = [1, 2, 3, 4, 5].sample.to_f
  unless reviewee == reviewer
    Review.create(
      reviewer: reviewer,
      reviewee: reviewee,
      title: ["Great!", "Beautiful!", "Such a sexy seller", "the man with the plan", "boom boom bam bam", "three roses and fistful of cash"].sample,
      rating: rating,
      content: "sample review content where the reviewer praises the reviewee admirably and also reveals a deep dark secret that should have not been revealed for the sake of everyone involved.",
    )

    if reviewee.rating
      # Update reviewee rating
      reviewee.rating = reviewee.reviewee_reviews.pluck(:rating).sum / reviewee.reviewee_reviews.length.to_f
    else
      reviewee.rating = rating
    end
    reviewee.save
  end
end
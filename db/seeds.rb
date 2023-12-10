# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "faker"
require 'unsplash'

Unsplash.configure do |config|
  config.application_access_key = ENV["UNSPLASH-API-KEY"]
  config.application_secret = ENV["UNSPLASH-API-SECRET"]
  config.utm_source = ENV["UNSPLASH-APP-NAME"]
end

["Clothing", "Electronics", "Toys", "Books", "Home", "Videogames", "Appliances", "Groceries", "Pet Supplies", "Sports"].each do |category_name|
  Category.create(name: category_name)
end

100.times do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  race = ["asian", "colombian", "white", "black", "european", "japanese", "brazilian", "canadian", "african", "middle eastern", "engineer", "teacher", "professor", "doctor", "surgeon", "nurse", "mom", "dad", "grandpa", "soldier"].sample
  User.create!(
    first_name: first_name,
    last_name: last_name,
    city: Faker::Address.city,
    country: Faker::Address.country,
    username: Faker::Internet.username + "_#{i}", # Start at user1 to avoid user0
    email: Faker::Internet.email,
    password: "testtest",
    rating: nil,
    image_url: Faker::LoremFlickr.image(search_terms: ["person", race]),
  )
  sleep 1
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
  admin: true,
  )

users = User.all
categories = Category.all

50.times do |i|
  name = Faker::Commerce.product_name
  Item.create!(
    price: Faker::Commerce.price,
    description: name,
    image_url: Unsplash::Photo.random(query: name).urls.full,
    for_sale: [true, true, true, false].sample,
    featured: [true, true, true, false, false, false, false, false, false, false].sample,
    featured_amount_paid: rand(1000).abs,
    category: categories.sample,
    user: users.sample # This will randomly assign a user to each item
  )
  sleep 1
end

items = Item.all
50.times do ||
  Chat.create(
    buyer: users.sample,
    seller: users.sample,
    item: items.sample,
  )
end


100.times do ||
  reviewee = users.sample
  reviewer = users.sample
  rating = [1, 2, 3, 4, 5].sample.to_f
  unless reviewee == reviewer
    Review.create(
      reviewer: reviewer,
      reviewee: reviewee,
      title: Faker::TvShows::Simpsons.quote,
      rating: rating,
      content: Faker::TvShows::BrooklynNineNine.quote,
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
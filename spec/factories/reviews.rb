FactoryBot.define do
  factory :review do
    rating { rand(1..5) }
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
    association :reviewer, factory: :user
    association :reviewee, factory: :user
  end
end
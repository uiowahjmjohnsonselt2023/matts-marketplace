FactoryBot.define do
  factory :item do
    price { 100 }
    description { Faker::Cannabis.strain }
    image_url { 'www' }
    for_sale { false }
    user_id { Faker::Number.unique.number(digits: 3) }

    transient do
      sequence(:category_name) { |n| "Category #{n}" }
    end

    category_id { create(:category, name: category_name).id }

    trait :invalid do
      price { 100 }
      description { nil }
      image_url { 'www' }
      for_sale { false }
      category_id { 1 }
      featured { false }
    end
    association :user, factory: :user
    ##association :user, factory: :user, username: 'superuser' (might use this later)
  end
end

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end
end

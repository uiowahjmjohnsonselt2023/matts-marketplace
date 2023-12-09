FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { |user| 'super' +  user.first_name }
    balance { 0.0 }
    rating { 0.0 }

    factory :user_with_items do
      email { Faker::Internet.unique.email }
      password { 'password' }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      username { |user| 'super' +  user.first_name }

      transient do
        items_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:item, evaluator.items_count, user: user)
    end
    end
  end
end
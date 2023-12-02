FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password' }
    first_name { 'John' }
    last_name { 'Doe' }
    username { 'superuser' }

    factory :user_with_items do
      transient do
        items_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:item, evaluator.items_count, user: user)
    end
    end
  end
end
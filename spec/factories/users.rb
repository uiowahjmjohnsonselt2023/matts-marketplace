FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password' }
    first_name { 'John' }
    last_name { 'Doe' }
    username { 'superuser' }
    transient do
      item_count { 0 }
    end

    after(:create) do |user, evaluator|
      create_list(:item, evaluator.item_count, user: user) if evaluator.item_count.positive?
    end
  end
end
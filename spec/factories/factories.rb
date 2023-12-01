FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    password { 'password' }
    first_name { 'John' }
    last_name { 'Doe' }
  end

  factory :item do
    description { 'Example Item' }
    category_id { 2 }
    for_sale { false }
  end
end
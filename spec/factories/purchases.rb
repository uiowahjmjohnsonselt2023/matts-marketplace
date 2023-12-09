FactoryBot.define do
  factory :purchase do
    association :seller, factory: :user
    association :buyer, factory: :user
    association :item
  end
end
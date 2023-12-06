FactoryBot.define do
  factory :chat do
    association :buyer, factory: :user
    association :seller, factory: :user
    association :item

    # Define messages association
    transient do
      messages_count { 5 } # Default number of messages
    end

    after(:create) do |chat, evaluator|
      create_list(:message, evaluator.messages_count, chat: chat)
    end
  end

  factory :message do
    association :user
    association :chat
  end
end
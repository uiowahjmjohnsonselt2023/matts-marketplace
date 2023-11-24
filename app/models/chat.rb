class Chat < ApplicationRecord
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  has_many :messages
  belongs_to :item
  after_create_commit { broadcast_append_to "chats" }
end

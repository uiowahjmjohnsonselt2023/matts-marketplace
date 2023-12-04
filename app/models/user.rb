class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :items
  has_and_belongs_to_many :wishlist_items, class_name: "Item"
  has_many :buyer_purchases, class_name: 'Purchase', foreign_key: 'buyer_id'
  has_many :seller_purchases, class_name: 'Purchase', foreign_key: 'seller_id'

  # Chat function references
  has_many :buyer_chats, class_name: 'Chat', foreign_key: 'buyer_id'
  has_many :seller_chats, class_name: 'Chat', foreign_key: 'seller_id'
  has_many :messages

  # Review references
  has_many :reviewer_reviews, class_name: 'Review', foreign_key: 'reviewer_id'
  has_many :reviewee_reviews, class_name: 'Review', foreign_key: 'reviewee_id'

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.first_name
    end
  end
end

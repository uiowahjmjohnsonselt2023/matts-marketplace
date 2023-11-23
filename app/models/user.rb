class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  has_many :items
  has_many :purchases, class_name: 'Purchase', foreign_key: 'purchase_id'
  has_many :sales, class_name: 'Purchase', foreign_key: 'sale_id'

  # Chat function references
  has_many :buyer_chats, class_name: 'Chat', foreign_key: 'buyer_id'
  has_many :seller_chats, class_name: 'Chat', foreign_key: 'seller_id'
  has_many :messages

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.first_name
    end
  end
end

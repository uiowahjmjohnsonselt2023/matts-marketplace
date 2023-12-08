Rails.application.routes.draw do
  get 'profile/show'
  get 'profile/edit'
  patch 'profile/update'
  get 'profile/wishlist'
  get 'profile/balance'
  post 'profile/add_balance', to: 'profile#add_balance', as: 'profile_add_balance'
  post 'profile/withdraw_balance', to: 'profile#withdraw_balance', as: 'profile_withdraw_balance'
  get 'home/index'
  get 'admin/manage_users'
  resources :purchases
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, path: 'u'
  resources :items do
    collection do
      get 'search'
      get 'simple_search'
      get 'category_search'
    end
    member do
      get 'edit'
    end
  end
  resources :buyers, only: [:index, :show] do
    member do
      get 'checkout'
      get 'confirm'
    end
  end
  resources :users
  resources :pages
  resources :chats do
    member do
      post 'send_message', to: "chats#send_message"
    end
  end
  post 'chats/create', to: 'chats#create', as: 'chats_create'
  post 'toggle_wishlist', to: 'items#toggle_wishlist', as: 'toggle_wishlist'
  get 'toggle_wishlist', to: 'items#toggle_wishlist'
  root to: 'home#index'

  # User auth routes
  get '\signup', to: 'users#new'

  # Seller routes
  get 'sellers', to: 'sellers#index', as: 'sellers'

end

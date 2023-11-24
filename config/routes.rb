Rails.application.routes.draw do
  get 'profile/show'
  get 'profile/edit'
  post 'profile/update'
  resources :chats
  get 'profile/show'
  get 'profile/edit'
  post 'profile/update'
  get 'profile/wishlist'
  resources :chats
  get 'home/index'
  resources :purchases
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, path: 'u'
  resources :items do
    collection do
      get 'search'
      get 'simple_search'
      get 'category_search'
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
  post 'toggle_wishlist', to: 'items#toggle_wishlist'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  root to: 'home#index'

  # User auth routes
  get '\signup', to: 'users#new'

end

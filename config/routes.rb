Rails.application.routes.draw do
  resources :chats
  get 'home/index'
  resources :purchases
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :items do
    collection do
      get 'search'
      get 'simple_search'
      get 'category_search'
    end
  end
  resources :buyers, only: [:index, :show]
  resources :users
  resources :pages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  root to: 'home#index'

  # User auth routes
  get '\signup', to: 'users#new'

end

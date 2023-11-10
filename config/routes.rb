Rails.application.routes.draw do
  devise_for :users
  resources :items
  resources :users
  resources :pages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: 'pages#home'

  # Defines the root path route ("/")
  # root "users#index" # Added this because it is required by devise, we can update this once we have an actual home page
  # root "home#index" # Added this because it is required by devise, we can update this once we have an actual home page


  # User auth routes
  get '\signup', to: 'users#new'

end

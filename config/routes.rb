Rails.application.routes.draw do
  get 'buyers/index'
  get 'buyers/show'
  resources :items
  resources :users
  resources :pages
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: 'pages#home'

end

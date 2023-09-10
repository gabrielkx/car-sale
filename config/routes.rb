Rails.application.routes.draw do
  root 'cars#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :cars
  resources :contacts, only: [:new, :create]

  # Defines the root path route ("/")
  # root "articles#index"
end

Rails.application.routes.draw do
  resources :organizations
  resources :locations
  resources :games
  resources :teams
  resources :leagues
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # # config/routes.rb

  get "public_files", to: "public_files#index"
end

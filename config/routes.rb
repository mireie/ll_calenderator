# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :organizations
  resources :locations
  resources :games
  resources :teams
  resources :leagues
  resource :registration, only: %i[new create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  # # config/routes.rb

  get "admin", to: "admin#index"
  get "leagues/:id/webcal", to: "leagues#webcal", as: "league_webcal"
  post "admin/refresh_all", to: "admin#refresh_all", as: "admin_refresh_all"
  get "teams/:id/webcal", to: "teams#webcal", as: "team_webcal"
  get "jobs/sync_games", to: "jobs#sync_games", as: "sync_games"

  # Sidekiq Web UI
  require "sidekiq/web"

  # authenticate :user, ->(user) { user.super? } do
  #   mount Sidekiq::Web => "/sidekiq"
  #   mount PgHero::Engine, at: "pghero" if defined?(PgHero)
  # end
end

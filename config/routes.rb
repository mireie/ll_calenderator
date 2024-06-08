# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :organizations
  resources :locations
  resources :games
  resources :teams
  resources :leagues
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "leagues#index"
  # # config/routes.rb

  get "leagues/:id/webcal", to: "leagues#webcal", as: "league_webcal"
  post "leagues/:id/refresh_games", to: "leagues#refresh_games", as: "league_refresh_games"
  post "leagues/:id/refresh_teams", to: "leagues#refresh_teams", as: "league_refresh_teams"
  get "admin", to: "admin#index"
  post "admin/refresh_all", to: "admin#refresh_all", as: "admin_refresh_all"
  get "teams/:id/webcal", to: "teams#webcal", as: "team_webcal"

  # Sidekiq Web UI
  require "sidekiq/web"

  authenticate :user, ->(user) { user.super? } do
    mount Sidekiq::Web => "/sidekiq"
    mount PgHero::Engine, at: "pghero" if defined?(PgHero)
  end
end

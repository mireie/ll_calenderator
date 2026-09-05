# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "pages#home"

  get "leagues/:id/webcal", to: "pages#calendar_discontinued", as: "league_webcal"
  get "teams/:id/webcal", to: "pages#calendar_discontinued", as: "team_webcal"

  match "*path", to: redirect("/"), via: :all, constraints: ->(request) { request.path != "/" }

  devise_for :users
  resources :organizations
  resources :locations
  resources :games
  resources :teams
  resources :leagues
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # # config/routes.rb

  get "admin", to: "admin#index"
  post "admin/refresh_all", to: "admin#refresh_all", as: "admin_refresh_all"
  get "jobs/sync_games", to: "jobs#sync_games", as: "sync_games"

  authenticate :user, ->(user) { user.super? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount PgHero::Engine, at: "pghero" if defined?(PgHero)
  end
end

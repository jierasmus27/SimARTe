require "sidekiq/web" # require the web UI
Rails.application.routes.draw do
  root to: "admin#show"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  namespace :admin do
    resources :subscriptions, only: %i[create destroy]
    resources :users, only: :index

    get "dashboard", to: "dashboard#show"
    get "services", to: "services#show"
    get "analytics", to: "analytics#show"
    get "settings", to: "settings#show"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  mount Sidekiq::Web => "/sidekiq"
end

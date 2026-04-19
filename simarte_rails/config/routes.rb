require "sidekiq/web" # require the web UI
Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root to: "admin#show"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  namespace :admin do
    resources :subscriptions, only: %i[create destroy]
    resources :users, only: %i[index create update]

    get "dashboard", to: "dashboard#show"
    get "services", to: "services#show"
    get "analytics", to: "analytics#show"
    get "settings", to: "settings#show"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  authenticate :user, lambda(&:admin?) do
    mount Sidekiq::Web => "/sidekiq"
  end
end

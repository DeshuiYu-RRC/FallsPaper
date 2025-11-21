Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # ActiveAdmin routes
  ActiveAdmin.routes(self)

  # Root route
  root "home#index"

  # Health check
  get "health", to: "health#index"
end

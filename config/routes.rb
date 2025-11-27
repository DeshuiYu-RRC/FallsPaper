Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # ActiveAdmin routes
  ActiveAdmin.routes(self)

  # Root route
  root "home#index"

  # Static pages
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  post "contact", to: "pages#send_contact"

  # Products routes
  resources :products, only: [:index, :show] do
    collection do
      get :search
      get :on_sale
      get :new_arrivals
      get :recently_updated
    end
  end

  # Categories routes
  resources :categories, only: [:index, :show]

  # Cart routes
  resource :cart, only: [:show] do
    post "add/:product_id", to: "carts#add", as: :add
    patch "update/:product_id", to: "carts#update", as: :update_item
    delete "remove/:product_id", to: "carts#remove", as: :remove
    delete :clear
  end

  # Checkout routes
  get "checkout", to: "checkouts#show"

  # Payment routes
  post "payments", to: "payments#create"
  get "payments/success", to: "payments#success"
  post "payments/webhook", to: "payments#webhook"

  # Orders routes (for logged in users)
  resources :orders, only: [:index, :show]

  # User profile
  resource :profile, only: [:show, :edit, :update]

  # Health check
  get "health", to: "health#index"
end

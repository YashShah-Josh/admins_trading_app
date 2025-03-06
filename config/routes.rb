Rails.application.routes.draw do
  # Devise for Admins only
  devise_for :admins, controllers: { registrations: "admins/registrations" }

  namespace :admins do
    resources :user_stocks, only: [:index, :show]
    resources :transactions, only: [:index, :show, :destroy]
    get "dashboard", to: "dashboard#index"
    resources :stocks
    resources :orders
  end
  devise_for :users, path: "auth", controllers: {
            registrations: "api/v1/users",
          }

  namespace :api do
    namespace :v1 do
      post "users/register", to: "users#register"
      post "users/login", to: "users#login"
      delete "users/logout", to: "users#logout"

      resources :stocks, only: [ :index ]

      resources :orders, only: [] do
        collection do
          post :buy
          post :sell
        end
      end
    end
  end

  authenticated :admin do
    root to: "admins/dashboard#index", as: :authenticated_admin_root
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  devise_scope :admin do
    root to: "devise/sessions#new"
  end
end

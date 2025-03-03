Rails.application.routes.draw do
  devise_for :users
  devise_for :admins, controllers: { registrations: "admins/registrations" }

  namespace :admins do
    get "dashboard", to: "dashboard#index"
    resources :stocks
    resources :orders
  end

  authenticated :admin do
    root to: "admins/dashboard#index", as: :authenticated_admin_root
  end

  # Remove these since stocks/orders are admin-only
  # resources :orders
  # resources :stocks

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#index"
end

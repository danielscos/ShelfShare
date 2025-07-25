Rails.application.routes.draw do
  # Main application routes
  resources :books
  resources :users, only: [ :new, :create, :show, :edit, :update ]
  resources :sessions, only: [ :new, :create ]

  # Authentication routes
  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "users#new"

  # Admin routes (protected by admin authorization)
  get "admin/dashboard"
  get "admin/users"
  get "admin/books"
  delete "admin/users/:id", to: "admin#delete_user", as: "admin_delete_user"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end

Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  get "/terms", to: "home#terms"
  get "privacy", to: "home#privacy"

  resources :users, only: [ :index, :show ]
  resources :shops  do
    resource :favorites, only: [ :create, :destroy ]
    collection { get :autocomplete }
  end
  get "/favorites", to: "users#favorite"
  get "/mail_test", to: "mail_test#send_mail"
  resource :onboarding, only: [ :update ]

  # ログインしている時のページを新規に開いた先
  authenticated :user do
    root to: "shops#index", as: :authenticated_root
  end
  # ログインしていない時のページを新規に開いた先
  unauthenticated do
    root to: "home#index"
  end

  get "diagnoses/new"
  post "diagnoses/result", to: "diagnoses#result"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end

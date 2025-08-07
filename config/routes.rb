Rails.application.routes.draw do
  devise_for :users
  root "home#index"
  resources :shops
  	authenticated :user do
	    root to: 'shops#index', as: :authenticated_root
    end
  get "diagnoses/new"
  post "diagnosis/result", to: "diagnoses#result", as: :diagnosis_result
  
  resources :users, only: [:index, :show]

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

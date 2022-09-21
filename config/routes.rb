Rails.application.routes.draw do
  resources :sessions, only: [:create]
  resources :registrations, only: [:create, :update, :destroy]
  resources :pets_profile, only: [:create, :update, :destroy]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  root to: "static#home"
end

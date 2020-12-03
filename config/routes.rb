Rails.application.routes.draw do
  root to: 'users#index'
  resources :users, except: [:destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :questions

  get 'sign_up' => 'users#new'
  get 'log_out' => 'sessions#destroy'
  get 'log_in' => 'sessions#new'
end

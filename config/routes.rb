Rails.application.routes.draw do
  root 'pages#home'
  get 'home', to: 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :roles
  resources :users
  resources :researches, except: [:index]
end

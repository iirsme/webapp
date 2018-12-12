Rails.application.routes.draw do
# root 'researches#index' 
  root 'pages#home'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :roles
  resources :users
end

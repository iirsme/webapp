Rails.application.routes.draw do
  root 'pages#home'
  get 'home', to: 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#logout'

  resources :roles

  resources :users

  resources :researches, except: [:index]
  post 'enter_research', to: 'researches#enter_research'
  get 'go_back_research', to: 'researches#back'
  
  resources :candidates

end

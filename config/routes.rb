Rails.application.routes.draw do
  root 'pages#home'
  get 'home', to: 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#logout'

  resources :roles

  resources :users
  
  resources :fields

  resources :researches, except: [:index]
  post 'enter_research', to: 'researches#enter_research'
  get 'go_back_research', to: 'researches#back'
  
  resources :candidates
  get 'get_audit', to: 'candidates#get_audit'

  get 'get_research_users', to: 'research_users#get_research_users'
  get 'add_research_user', to: 'research_users#add_research_user'
  get 'delete_research_user', to: 'research_users#delete_research_user'

  get 'get_research_tabs', to: 'tabs#get_research_tabs'
  get 'add_research_tab', to: 'tabs#add_research_tab'
  get 'update_research_tab', to: 'tabs#update_research_tab'
  get 'delete_research_tab', to: 'tabs#delete_research_tab'

  get 'add_fields_to_tab', to: 'research_fields#add_fields'

end

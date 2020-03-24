Rails.application.routes.draw do
  root 'pages#home'
  get 'home', to: 'pages#home'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'logout', to: 'sessions#logout'

  get 'database_report', to: 'reports#index'
  get 'get_database_report', to: 'reports#get_report'

  resources :roles

  resources :users
  
  resources :fields

  resources :researches, except: [:index]
  post 'enter_research', to: 'researches#enter_research'
  get 'go_back_research', to: 'researches#back'
  get 'get_report', to: 'researches#get_report'

  resources :candidates

  get 'get_research_users', to: 'research_users#get_research_users'
  get 'add_research_user', to: 'research_users#add_research_user'
  get 'delete_research_user', to: 'research_users#delete_research_user'
  get 'get_research_tabs', to: 'tabs#get_research_tabs'
  get 'add_research_tab', to: 'tabs#add_research_tab'
  get 'update_research_tab', to: 'tabs#update_research_tab'
  get 'delete_research_tab', to: 'tabs#delete_research_tab'
  get 'add_fields_to_tab', to: 'research_fields#add_fields'
  get 'add_label_to_research', to: 'research_fields#add_label'
  get 'delete_research_label', to: 'research_fields#delete_label'
  get 'get_research_labels', to: 'research_fields#get_labels'
  get 'get_research_summary', to: 'researches#get_summary'

  resources :patients

  resources :appointments
  get 'add_patient_appointment', to: 'appointments#add_patient_appt'
  get 'delete_patient_appointment', to: 'appointments#delete_patient_appt'

  get 'see_evaluation', to: 'evaluations#show'
 
  get 'get_audit', to: 'audits#get_audit'
  
end

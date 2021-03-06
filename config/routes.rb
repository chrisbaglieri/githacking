Githacking::Application.routes.draw do

  root to: "pages#home"
  
  match "about" => 'pages#about'
  match "faq" => 'pages#faq'
  match "terms" => 'pages#terms'
  match "privacy" => 'pages#privacy'

  match '/users/oauth' => 'users#create', as: 'oauth_callback'

  resource :user_session
  match '/logout' => 'user_sessions#destroy', as: 'logout'
  match '/login' => 'user_sessions#new', as: 'login'

  resource :account, controller: 'users'
  resources :users, path: ''  do
    # Doing resources here screws with users routing
    constraints id: /[^\/]+/ do
      get '/:id' => 'repositories#show', as: 'repository'
      get '/:repository_id/issues(/:tag)' => 'repositories#issues', as: 'repository_issues'
    end
  end
end

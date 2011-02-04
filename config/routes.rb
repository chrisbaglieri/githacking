Githacking::Application.routes.draw do

  root to: 'repositories#index'
  match '/users/oauth' => 'users#create', as: 'oauth_callback'

  resource :user_session
  match '/logout' => 'user_sessions#destroy', as: 'logout'
  match '/login' => 'user_sessions#new', as: 'login'

  resource :account, controller: 'users'
  resources :users, path: ''  do
    # Doing resources here screws with users routing
    get '/:id' => 'repositories#show', as: 'repository'
  end
  
end

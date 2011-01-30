Githacking::Application.routes.draw do

  root to: 'repositories#index'
  match '/users/oauth' => 'users#create', as: 'oauth_callback'

  resources :users
  resource :account, controller: 'users'
  resource :user_session
  match '/logout' => 'user_sessions#destroy', as: 'logout'
  match '/login' => 'user_sessions#new', as: 'login'

  resources :repositories do
    collection do
      get 'search'
    end
  end
  
end

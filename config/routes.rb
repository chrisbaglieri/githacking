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

  # GitHub reserves /account for user account settings, so we can take
  # advantage of that for our own logged in user page.
  resource :account, controller: 'users'
  resources :users, path: ''  do
    # Doing `resources :repositories` here screws with users routing,
    # and we don't need anything but show for repositories anyway
    constraints id: /[^\/]+/ do
      get '/:id' => 'repositories#show', as: 'repository'
      get '/:repository_id/issues(/:tag)' => 'repositories#issues', as: 'repository_issues'
    end
  end

  # Have to do this outside the nested resource so we get reasonable
  # named route generation without using `resources :metadata`
  get '/:user_id/:repository_id/metadata/new' => 'metadata#new', as: 'new_user_repository_metadata'
  get '/:user_id/:repository_id/metadata/edit' => 'metadata#edit', as: 'edit_user_repository_metadata'
  post '/:user_id/:repository_id/metadata' => 'metadata#create', as: 'user_repository_metadata'

end

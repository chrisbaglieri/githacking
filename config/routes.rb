Githacking::Application.routes.draw do

  root to: 'repositories#index'
  
  resources :repositories
  
end

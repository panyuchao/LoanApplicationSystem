
LoanApplicationSystem::Application.routes.draw do
  get "en/index"

  get "ch/index"

	root :to => 'ch#index'
  
  resources :apps
  resources :ch do
      match 'apply' => 'ch#apply'
  end
  match 'ch/index' => 'ch#index'
  match '/:ver/:current_user/apps' => 'apps#index'
  
  # User 
  match "/:ver/login" => 'user#login'
  match "/:ver/:current_user/logout" => 'user#logout'
  
  # App
  match "/:ver/:current_user/new_(:app_type)_app" => 'apps#new_app'
  
  resources :en do
      match 'apply' => 'en#apply'
  end
end

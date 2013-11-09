
LoanApplicationSystem::Application.routes.draw do
  get "en/index"

  get "ch/index"

	root :to => 'ch#index'

  resources :apps
  resources :ch do
      match 'apply' => 'ch#apply'
  end
  resources :en do
      match 'apply' => 'en#apply'
  end
end

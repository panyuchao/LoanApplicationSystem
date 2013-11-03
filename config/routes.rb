
LoanApplicationSystem::Application.routes.draw do
  get "en/index"

  get "ch/index"

	root :to => 'ch#index'

  resources :ch do
      match 'apply' => 'ch#apply'
  end
end

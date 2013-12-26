
LoanApplicationSystem::Application.routes.draw do
	root :to => 'user#login'
  
  resources :apps
  
  match '/:ver/:current_user/apps' => 'apps#show_forms'
  match '/:ver/:current_user/wait_for_verify' => 'apps#wait_for_verify'
  match "/:ver/:current_user/reviewed" => 'apps#reviewed'
  
  # User 
  match "/:ver/login" => 'user#login'
  match "/:ver/:current_user/logout" => 'user#logout'
  
  # App
  

  match "/:ver/:details/delete" => 'apps#delete'
  match "/:ver/:details/check" => 'apps#check'
  match "/:ver/:current_user/user_management" => 'apps#user_management'
  match "/:ver/:user_name/removeuser" => 'user#remove'
  match "/:ver/:current_user/new_user" => 'apps#new_user'
  match "/:ver/:current_user/new_userc" => 'user#new_userc'
  match "/:ver/:current_user/change_to_status_(:s1)_from_(:s0)/:id" => 'apps#changes'  
  
  # Form
  match "/:ver/:current_user/new_(:app_type)_form" => 'forms#new_form'
  match "/:ver/:current_user/export" => 'apps#export'
  
  #Output PDF
  match "/:ver/:current_user/output" => "apps#output"
  
end

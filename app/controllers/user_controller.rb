class UserController < ApplicationController
	def login
		if params[:user] != nil then
			@current_user = User.find_by_user_name(params[:user][:username])
			if @current_user != nil && @current_user.user_pass == params[:user][:password] then
				session[:current_user] = params[:user]
				session[:is_admin] = @current_user.is_admin
				flash[:notice] = "#{session[:is_admin]}"
				redirect_to "/#{params[:ver]}/#{@current_user.user_name}/apps"
			else
				flash[:notice] = "Invalid username/password!"
				redirect_to "/#{params[:ver]}/index"
			end
		end
	end
	
	def logout
		session[:current_user] = session[:is_admin] = nil
		flash[:notice] = "Logout succeeded!"
		redirect_to "/#{params[:ver]}/index"
	end

end

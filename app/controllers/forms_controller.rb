class FormsController < ApplicationController
	def check_username
		if session[:current_user] == nil then
			flash[:notice] = "Login timed out!"
			if params[:ver] != nil
				redirect_to "/#{params[:ver]}/index" 
			else
				redirect_to "/ch/index"
			end
			return true
		end
		if params[:current_user] != session[:current_user][:username] then
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return true
		end
		return false
	end
	
	def new_form
		@TOT_APPS = Form.TOT_APPS
		if check_username then return end
		@current_user = User.find_by_user_name(session[:current_user][:username])
		if params[:commit] != nil && params[:app][:details] != '' then
			valid_form = true 
			
			
		else
			if params[:commit] != nil then
				flash[:notice] = "#{params[:app_type]}Details should not be empty!"
				#redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_app"
			end
		end
	end
end

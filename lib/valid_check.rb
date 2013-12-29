# encoding: utf-8
module ValidCheck
	def check_username
		if session[:current_user] == nil then
			flash[:error] = params[:ver] == 'ch'? "登陆超时" : "Login timed out"
			if params[:ver] != nil
				redirect_to "/#{params[:ver]}/login" 
			else
				redirect_to "/ch/login"
			end
			return 
		end
		if params[:current_user] != session[:current_user][:username] then 
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps"
		end
		@current_user = User.find_by_user_name(session[:current_user][:username])
	end
	
	def check_admin
		if !@current_user.is_admin then
			flash[:error] = params[:ver] == 'ch'? "你没有权限这样做" : "You don't have privilege!"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps"
		end
	end
end

# encoding: utf-8
require 'valid_check'
require 'yaml'

class UserController < ApplicationController
	include ValidCheck
	
	before_filter :check_username, :only => ['user_management', 'edit_profile', 'save_profile', 'add_user']
	before_filter :check_admin, :only => ['user_management', 'add_user']
	
	def index
		if session[:current_user] != nil
			redirect_to "/ch/#{session[:current_user][:username]}/apps" and return
		else
			redirect_to "/ch/login"
		end
	end

	def init
		@current_user = User.find_by_ticket(params[:ticket])
		if params[:commit] then
			if params[:user_name] == nil || params[:realname] == "" then
			    flash[:error] = params[:ver] == 'ch'? "用户名不能为空" : "User name should not be empty"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end
			if params[:user_name] != @current_user.user_name and User.find_by_user_name(params[:user_name]) != nil then
			    flash[:error] = params[:ver] == 'ch'? "该用户名已存在" : "This user name has existed"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end
			if params[:realname] == nil || params[:realname] == "" then
			    flash[:error] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end
	  		if !params[:email].match(/^(.+)\@(.+)$/) then
	  		  flash[:error] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end

			if params[:email] != @current_user.email and User.find_by_email(params[:email]) != nil then
			    flash[:error] = params[:ver] == 'ch'? "该邮箱已存在" : "This user name has existed"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end
			if params[:new_password] == '' or params[:new_password] == nil then
	  			flash[:error] = params[:ver] == 'ch' ? "密码不能为空" : "Password should not be empty"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return	
			end		
	  		if params[:new_password] != params[:verify_password] then
	  			flash[:error] = params[:ver] == 'ch' ? "两次填写密码不一致" : "Inconsistent password"
	  		  redirect_to "/#{params[:ver]}/initialize/#{params[:ticket]}" and return
	  		end

	  		@current_user.update_attributes!(:user_name => params[:user_name], :realname => params[:realname], :email => params[:email])
			session[:current_user][:username] = @current_user.user_name			  				
			@current_user.update_attributes!(:user_pass => params[:new_password], :ticket => '')
			session[:current_user][:password] = @current_user.user_pass
			session[:is_admin] = @current_user.is_admin
	  		flash[:success] = params[:ver] == 'ch' ? "操作成功" : "Save Successfully"
	  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return

		end

		if @current_user == nil or params[:ticket].length != 64 then
			redirect_to "/ch/login" and return
		end
		render 'init'		
	end
	
	def login
		if params[:user] != nil then
			if params[:user][:username] =~ /(.+)\@(.+)\.(.+)$/i	
				@current_user = User.find_by_email(params[:user][:username])
				params[:user][:username] = @current_user.user_name
			else
				@current_user = User.find_by_user_name(params[:user][:username])
			end
			if @current_user.ticket != '' and @current_user.ticket != nil then
				flash[:error] = "User is not initialized!"
				redirect_to "/#{params[:ver]}/login"
			end
			if @current_user != nil && @current_user.user_pass == params[:user][:password] then
				session[:current_user] = params[:user]
				session[:is_admin] = @current_user.is_admin
				redirect_to "/#{params[:ver]}/#{@current_user.user_name}/apps"
			else
				flash[:error] = "Invalid username/password!"
				redirect_to "/#{params[:ver]}/login"
			end
		end
	end
	
	def logout
		session[:current_user] = session[:is_admin] = nil
		flash[:success] = "Logout succeeded!"
		redirect_to "/#{params[:ver]}/login"
	end
	
	def remove
		username = params[:user_name]
		delist = User.find_by_user_name(username)
		if(session[:is_admin] == true && delist != nil)
			User.destroy(delist)
			flash[:success] = "#{username} has been removed."
		else
			flash[:error] = "No permission"
		end
		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/user_management"
	end

	def user_management
		@current_user = User.find_by_user_name(session[:current_user][:username])
		@user = User.all
		@check_status_num = Form.get_check_status_num
	end

	def edit_profile
                if !session[:is_admin]
			@check_status_num = Form.get_check_status_num
			if params[:commit] then
				if params[:password] != @current_user.user_pass then
					flash[:error] = params[:ver] == 'ch' ? "密码填写错误" : "Wrong password"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
			end
			if params[:user_name] == nil || params[:realname] == "" then
			    flash[:error] = params[:ver] == 'ch'? "用户名不能为空" : "User name should not be empty"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
			if params[:user_name] != @current_user.user_name and User.find_by_user_name(params[:user_name]) != nil then
			    flash[:error] = params[:ver] == 'ch'? "该用户名已存在" : "This user name has existed"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
			if params[:realname] == nil || params[:realname] == "" then
			    flash[:error] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		if !params[:email].match(/^(.+)\@(.+)$/) then
	  		  flash[:error] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
			if params[:email] != @current_user.email and User.find_by_email(params[:email]) != nil then
			    flash[:error] = params[:ver] == 'ch'? "该邮箱已存在" : "This user name has existed"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		if params[:new_password] != params[:verify_password] then
	  			flash[:error] = params[:ver] == 'ch' ? "两次填写密码不一致" : "Inconsistent password"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		
	  		@current_user.update_attributes!(:user_name => params[:user_name], :realname => params[:realname], :email => params[:email])
			session[:current_user][:username] = @current_user.user_name
	  		if params[:new_password] != nil && params[:new_password] != "" then
	  			@current_user.update_attributes!(:user_pass => params[:new_password])
	  		end
	  		flash[:success] = params[:ver] == 'ch' ? "操作成功" : "Save Successfully"
	  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
			end
			render 'user_edit_profile'
		else
			@check_status_num = Form.get_check_status_num
			@nemail = ActionMailer::Base.smtp_settings[:user_name]
			my_rails_root = File.expand_path('../../..', __FILE__)
			configs = YAML::load_file("#{my_rails_root}/config/config.yml")
			@domain = configs["domain"].to_s
			if params[:commit] then
				if params[:password] != @current_user.user_pass then
					flash[:error] = params[:ver] == 'ch' ? "密码填写错误" : "Wrong password"
	  		                redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
				end
				if params[:user_name] == nil || params[:user_name] == "" then
				    flash[:error] = params[:ver] == 'ch'? "用户名不能为空" : "User name should not be empty"
		  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
		  		end
				if params[:user_name] != @current_user.user_name and User.find_by_user_name(params[:user_name]) != nil then
				    flash[:error] = params[:ver] == 'ch'? "该用户名已存在" : "This user name has existed"
		  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
		  		end
			        if params[:realname] == nil || params[:realname] == "" then
			         	flash[:error] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  			if !params[:email].match(/^(.+)\@(.+)$/) then
	  		  		flash[:error] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
				if params[:email] != @current_user.email and User.find_by_email(params[:email]) != nil then
				    flash[:error] = params[:ver] == 'ch'? "该邮箱已存在" : "This user name has existed"
		  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
		  		end
				if !params[:nemail].match(/^(.+)\@(.+)$/) then
	  		  		flash[:error] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
				if params[:domain] == nil or params[:domain] == '' then
	  		  		flash[:error] = params[:ver] == 'ch' ? "域名不能为空" : "Domain name should not be empty"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  			if params[:new_password] != params[:verify_password] then
	  				flash[:error] = params[:ver] == 'ch' ? "两次填写密码不一致" : "Inconsistent password"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  		
	  			@current_user.update_attributes!(:user_name => params[:user_name], :realname => params[:realname], :email => params[:email])
				session[:current_user][:username] = @current_user.user_name
	  			if params[:new_password] != nil && params[:new_password] != "" then
	  				@current_user.update_attributes!(:user_pass => params[:new_password])
	  			end
				ActionMailer::Base.smtp_settings[:user_name] = params[:nemail]
			        configs["domain"] = params[:domain]
				File.open("#{my_rails_root}/config/config.yml", 'w') {|f| f.write configs.to_yaml }
				if params[:email_password] != nil && params[:email_password] != "" then
					ActionMailer::Base.smtp_settings[:password] = params[:email_password]
				end
	  			flash[:success] = params[:ver] == 'ch' ? "操作成功" : "Save Successfully"
	  			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
			end
			render 'admin_edit_profile'
		end
	end
	
	def add_user
		@check_status_num = Form.get_check_status_num
		if params[:commit] then
			if params[:realname] == nil or params[:realname] == '' then
			         flash[:notice] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  	 redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/add_user" and return
			end
			if !params[:email].match(/^(.+)\@(.+)\.(.+)$/) then
	  			 flash[:notice] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  	 redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/add_user" and return
	  		end
			if User.find_by_email(params[:email]) != nil then
	  			 flash[:notice] = "已存在此用户"
	  		  	 redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/add_user" and return
			end
			if params[:is_admin] == "是" then
			         is_admin = true
			else
				 is_admin = false
			end
			
			User.create!(:email => params[:email], :realname => params[:realname], :is_admin => is_admin)
			new_user = User.find_by_email(params[:email])
			user_name = "user" + new_user.id.to_s
			letter = [('0'..'9'), ('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
			ticket = (0...64).map { letter[rand(letter.length)] }.join
			new_user.update_attributes!(:user_name => user_name, :ticket => ticket)
			send_email(new_user)
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/user_management" and return
		end
		render 'admin_add_user'
	end

	def send_email(new_user)
		mailfrom = ActionMailer::Base.smtp_settings[:user_name]		
		mailto = new_user.email
		subject = "IIIS财务报销申请系统用户注册通知邮件"
		date = Time.now
		my_rails_root = File.expand_path('../../..', __FILE__)
		configs = YAML::load_file("#{my_rails_root}/config/config.yml")
		domain = configs["domain"].to_s
		url = 'http://' + domain + '/ch/initialize/' + new_user.ticket + '/'
      		body = {
      		  :applicant => new_user.realname, 
        	  :admin_name => session[:current_user][:realname],
		  :url => url
      		}                        
      		UserMailer.new_user_email(:subject => subject, :to => mailto, :from => mailfrom, :date => date, :body => body).deliver
	end
end

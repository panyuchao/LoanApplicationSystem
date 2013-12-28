# encoding: utf-8
require 'valid_check'

class UserController < ApplicationController
	include ValidCheck
	
	before_filter :check_username, :only => ['user_management', 'edit_profile', 'save_profile']
	before_filter :check_admin, :only => ['user_management']
	
	def index
		if session[:current_user] != nil
			redirect_to "/ch/#{session[:current_user][:username]}/apps" and return
		else
			redirect_to "/ch/login"
		end
	end
	
	def login
		if params[:user] != nil then
			if params[:user][:username] =~ /(.*)@(.*).(.*)$/i	
				@current_user = User.find_by_email(params[:user][:username])
				params[:user][:username] = @current_user.user_name
			else
				@current_user = User.find_by_user_name(params[:user][:username])
			end
			if @current_user != nil && @current_user.user_pass == params[:user][:password] then
				session[:current_user] = params[:user]
				session[:is_admin] = @current_user.is_admin
				redirect_to "/#{params[:ver]}/#{@current_user.user_name}/apps"
			else
				flash[:notice] = "Invalid username/password!"
				redirect_to "/#{params[:ver]}/login"
			end
		end
	end
	
	def logout
		session[:current_user] = session[:is_admin] = nil
		flash[:notice] = "Logout succeeded!"
		redirect_to "/#{params[:ver]}/login"
	end
	
	def remove
		username = params[:user_name]
		delist = User.find_by_user_name(username)
		if(session[:is_admin] == true && delist != nil && delist[:is_admin] == false)
			User.destroy(delist)
			flash[:notice] = "#{username} has been removed."
		else
			flash[:notice] = "No permission"
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
					flash[:notice] = params[:ver] == 'ch' ? "密码填写错误" : "Wrong password"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
				end
			  if params[:realname] == nil || params[:realname] == "" then
			    flash[:notice] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		if !params[:email].match(/^(.+)\@(.+)$/) then
	  		  flash[:notice] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		if params[:new_password] != params[:verify_password] then
	  			flash[:notice] = params[:ver] == 'ch' ? "两次填写密码不一致" : "Inconsistent password"
	  		  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  		end
	  		
	  		@current_user.update_attributes!(:realname => params[:realname], :email => params[:email])
	  		if params[:new_password] != nil && params[:new_password] != "" then
	  			@current_user.update_attributes!(:user_pass => params[:new_password])
	  		end
	  		flash[:notice] = params[:ver] == 'ch' ? "操作成功" : "Save Successfully"
	  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
			end
			render 'user_edit_profile'
		else
			@check_status_num = Form.get_check_status_num
			if params[:commit] then
				if params[:password] != @current_user.user_pass then
					flash[:notice] = params[:ver] == 'ch' ? "密码填写错误" : "Wrong password"
	  		                redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
				end
			        if params[:realname] == nil || params[:realname] == "" then
			         	flash[:notice] = params[:ver] == 'ch'? "姓名不能为空" : "Name should not be empty"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  			if !params[:email].match(/^(.+)\@(.+)$/) then
	  		  		flash[:notice] = params[:ver] == 'ch' ? "邮箱填写错误" : "Wrong Email address"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  			if params[:new_password] != params[:verify_password] then
	  				flash[:notice] = params[:ver] == 'ch' ? "两次填写密码不一致" : "Inconsistent password"
	  		  		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/edit_profile" and return
	  			end
	  		
	  			@current_user.update_attributes!(:realname => params[:realname], :email => params[:email])
	  			if params[:new_password] != nil && params[:new_password] != "" then
	  				@current_user.update_attributes!(:user_pass => params[:new_password])
	  			end
				
				if params[:email_password] != nil && params[:email_password] != "" then
					ActionMailer::Base.smtp_settings[:password] = params[:email_password]
				end
	  			flash[:notice] = params[:ver] == 'ch' ? "操作成功" : "Save Successfully"
	  			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
			end
			render 'admin_edit_profile'
		end
	end
end

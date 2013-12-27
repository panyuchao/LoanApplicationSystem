# encoding: utf-8
require 'valid_check'
class AppsController < ApplicationController
	include ValidCheck
	
	before_filter :check_username, :only => ['output', 'show_forms', 'wait_for_verify', 'failed_to_verify', 'reviewed']
	before_filter :check_admin, :only => ['output', 'wait_for_verify', 'failed_to_verify', 'reviewed']
	
	def show
#		id = params[:id] # retrieve movie ID from URI route
		# will render app/views/movies/show.<extension> by default
	end
	
	def index
	end

	def output
		@apps = App.order(:form_id)
		respond_to do |format|
			format.html
			format.csv { send_data @apps.to_csv }
			format.xls { send_data @apps.to_csv(col_sep: "\t") }
			format.pdf {
				@apps.to_pdf
				File.open("output.pdf", 'rb') do |f| 
					send_data f.read, :disposition => "inline",:stream => false,:filename => 'result.pdf'
				end
			}
		end
	end

	def show_forms
		if @current_user.is_admin then  # admin default - show all the unchecked apps
			@get_forms = Form.find(:all, :conditions => {:check_status => 0})
			@check_status_num = Form.get_check_status_num
			render "admin_show"
		else  # user default - show all my unchecked apps
			@apps_reim = @current_user.forms
			render "user_show"
		end
	end

	def new
		# default: render 'new' template
	end

	def delete
		@form_now = Form.find_by_id(params[:id])
		flash[:notice] = @form_now
		if @form_now != nil && @form_now.check_status == 0
  		@form_now.destroy
  	end
		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps"
	end


	def edit
	end

	def update
	end

	def destroy
	end

	def changes
		statusx = params[:s0].to_i
		statusy = params[:s1].to_i
		if bad_change_status(statusx, statusy) then
			flash[:notice] = "Status#{statusx} cannot change to Status#{statusy}"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
		end
		@form_now = Form.find(params[:id])
		if @form_now == nil then
			flash[:notice] = "Form with id{#{params[:id]} doesn't exist!"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[(statusx+1)>>1][1]}" and return
		end
		if params[:delete] != nil then statusy = 0; end
		if statusx == 1 && statusy == 3 then
			@form_now.apps.each do |appi|
				appi.account_num = params[:account_num][appi.id.to_s].to_s
				if !appi.account_num.match(/\d+/) then
					flash[:notice] = "#{params[:account]} Invalid Account number!"
					redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[(statusx+1)>>1][1]}" and return
				end
			end
			@form_now.apps.each do |appi|
				appi.save!
			end
		end
		@form_now.check_status = statusy
		@form_now.save!
		flash[:notice] = "操作成功"
		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[(statusx+1)>>1][1]}"
		send_email(@form_now.id, statusx, statusy)
	end

	def bad_change_status(statusx, statusy)
		return (statusx == statusy) || (statusx == 0 && statusy > 2 ) || (statusx > 2 && statusy == 0)
	end

	def wait_for_verify
		@get_forms = Form.find(:all, :conditions => {:check_status => 1})
		@check_status_num = Form.get_check_status_num
	end
	
	def failed_to_verify
	  @get_forms = Form.find(:all, :conditions => {:check_status => 2})
	  @check_status_num = Form.get_check_status_num
	end
		
	def reviewed
		@get_forms = Form.find(:all, :conditions => {:check_status => 3})
		@check_status_num = Form.get_check_status_num
		render "admin_reviewed"
	end

	def send_email(form_id, statusx, statusy)
		this_form = Form.find_by_id(form_id)
		applicant_id = Form.find_by_id(form_id).user_id
		applicant = User.find_by_id(applicant_id)
		mailto = applicant.email
		if mailto == nil || (mailto =~ /(.*)@(.*)\.(.*)$/i) == false then
			return
		end
		mailfrom = ActionMailer::Base.smtp_settings[:user_name]	
		subject = "IIIS财务报销申请系统通知邮件"	
		date = Time.now
		if statusx == 0 and statusy == 1 then
			body = "#{applicant.user_name}，您好！\n    您在#{this_form.created_at.strftime("%Y-%m-%d %H:%M:%S")}提交的#{Form.get_app_type.keys[Form.get_app_type[this_form.app_type]]}申请已被管理员#{session[:current_user][:username]}接受。\n    请继续关注后续消息。\n    谢谢！\n"
		elsif statusx == 0 and statusy == 2 then
			body = "#{applicant.user_name}，您好！\n    您在#{this_form.created_at.strftime("%Y-%m-%d %H:%M:%S")}提交的#{Form.get_app_type.keys[Form.get_app_type[this_form.app_type]]}申请已被管理员#{session[:current_user][:username]}拒绝。\n    谢谢！\n"
		elsif statusx == 1 and statusy == 3 then
			body = "#{applicant.user_name}，您好！\n    您在#{this_form.created_at.strftime("%Y-%m-%d %H:%M:%S")}提交的#{Form.get_app_type.keys[Form.get_app_type[this_form.app_type]]}申请已被管理员#{session[:current_user][:username]}确认。\n    请登录系统查询账号。\n    谢谢！\n"
		else
			return		
		end
		UserMailer.send_mail(:subject => subject, :to => mailto, :from => mailfrom, :date => date, :body => body).deliver
		
	end
	
end

# encoding: utf-8

class AppsController < ApplicationController
	before_filter :check_username, :only => ['output', 'show_forms', 'wait_for_verify', 'reviewed', 'user_management']
	before_filter :check_admin, :only => ['output', 'wait_for_verify', 'reviewed', 'user_management']
	def show
#		id = params[:id] # retrieve movie ID from URI route
		# will render app/views/movies/show.<extension> by default
	end


	def check_username
		if session[:current_user] == nil then
			flash[:notice] = "Login timed out!"
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
			flash[:notice] = params[:ver] == 'ch'? "你没有权限这样做" : "You don't have privilege!"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps"
		end
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
		times = params[:details]
		delist = {}
		App.all.each do |a|
			if a.created_at.to_i.to_s == times
				delist = a
			end
		end
		#delist = App.find_by_created_at(times.to_i)
		if(delist == nil || delist == {} || ( delist[:applicant] != session[:current_user][:username] && session[:is_admin] == false) )
			flash[:notice] = "No permission"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
		end
		App.destroy(delist)
		flash[:notice] = "#{times} has been removed."
		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps"
	end


	def edit
	end

	def update
	end

	def destroy
	end
        
        def user_management
 	    @current_user = User.find_by_user_name(session[:current_user][:username])
            @user = User.all
            @check_status_num = Form.get_check_status_num
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
		@get_forms = Form.find(:all, :conditions => {:check_status => [1, 2]})
		@check_status_num = Form.get_check_status_num
	end
		
	def reviewed
		@get_forms = Form.find(:all, :conditions => {:check_status => [3,4]})
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

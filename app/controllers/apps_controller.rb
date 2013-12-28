# encoding: utf-8
require 'valid_check'
class AppsController < ApplicationController
	include ValidCheck
	
	before_filter :check_username, :only => ['search', 'show_forms', 'wait_for_verify', 'failed_to_verify', 'reviewed', 'ended_apps']
	before_filter :check_admin, :only => ['search', 'wait_for_verify', 'failed_to_verify', 'reviewed', 'ended_apps']
	
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
				@apps.to_pdf session[:form], session[:start_time], session[:end_time]
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
#		flash[:notice] = @form_now
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
		if check_change_status(statusx, statusy) == false then
			flash[:error] = "Status#{statusx} cannot change to Status#{statusy}"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/apps" and return
		end
		@form_now = Form.find(params[:id])
		if @form_now == nil then
			flash[:error] = "Form with id{#{params[:id]} doesn't exist!"
			redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[statusx][1]}" and return
		end
		if params[:delete] != nil then statusy = 2; end
		if statusx == 1 && statusy == 3 then
		  if @form_now.apps.length < 8 then
			  @form_now.apps.each do |appi|
				  appi.account_num = params[:account_num][appi.id.to_s].to_s
				  if !appi.account_num.match(/^\d+$/) then
					  flash[:error] = "Invalid Account number!"
					  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[statusx][1]}" and return
				  end
			  end
			else
			  @form_now.apps.each do |appi|
				  appi.account_num = params[:account_num].to_s
				  if !appi.account_num.match(/^\d+$/) then
					  flash[:error] = "Invalid Account number!"
					  redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[statusx][1]}" and return
				  end
			  end
			end
		  @form_now.apps.each do |appi|
			  appi.save!
		  end
		end
		@form_now.check_status = statusy
		@form_now.save!
		flash[:success] = "操作成功"
		send_email(@form_now.id, statusx, statusy)
		redirect_to "/#{params[:ver]}/#{session[:current_user][:username]}/#{Form.get_admin_tags[statusx][1]}"
	end

	def check_change_status(statusx, statusy)
		Form.get_change_status.each do |x|
		  if x[0] == statusx && x[1] == statusy then
		    return true
		  end
		end
		return false
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
	
	def ended_apps
	  @get_forms = Form.find(:all, :conditions => {:check_status => 4})
	  @check_status_num = Form.get_check_status_num
	end

  def send_email(form_id, statusx, statusy)
    unless (statusx == 1 and statusy == 3) or (statusx == 0 and statusy == 2)
      return
    end
    this_form = Form.find_by_id(form_id)
    applicant_id = Form.find_by_id(form_id).user_id
    applicant = User.find_by_id(applicant_id)
    mailto = applicant.email
    if mailto == nil || (mailto =~ /(.*)@(.*)\.(.*)$/i) == false then
      return
    end
    mailfrom = ActionMailer::Base.smtp_settings[:user_name]        
    subject = "IIIS财务报销申请系统审核通知邮件"        
    date = Time.now
    if statusx == 1 and statusy == 3 then
      body = {
        :applicant => applicant.realname, 
        :form_created => this_form.created_at.strftime("%Y-%m-%d %H:%M:%S"), 
        :app_type => Form.get_app_type.keys[Form.get_app_type[this_form.app_type]], 
        :admin_name => session[:current_user][:realname]
      }                        
      UserMailer.accept_email(:subject => subject, :to => mailto, :from => mailfrom, :date => date, :body => body).deliver
      #return if request.xhr?
    elsif statusx == 0 and statusy == 2 then
            body = {
                    :applicant => applicant.realname, 
                    :form_created => this_form.created_at.strftime("%Y-%m-%d %H:%M:%S"), 
                    :app_type => Form.get_app_type.keys[Form.get_app_type[this_form.app_type]], 
                    :admin_name => session[:current_user][:realname]
                    }        
            UserMailer.reject_email(:subject => subject, :to => mailto, :from => mailfrom, :date => date, :body => body).deliver
            #return if request.xhr?
    else
      return
    end
      #UserMailer.send_mail(:subject => subject, :to => mailto, :from => mailfrom, :date => date, :body => body).deliver
  end
	
	def search
	  @check_status_num = Form.get_check_status_num
	  if params[:commit] == nil then
	    if params[:output] != nil then
	      redirect_to "/#{params[:ver]}/#{params[:current_user]}/output.pdf" and return
	    end
	    @get_forms = Form.where("created_at < :start_time", :start_time => '1900-1-1')
	  else
	    params[:start_time] = params[:search][:'start_time(1i)'] + "-" + (params[:search][:'start_time(2i)'].length == 1? "0" : "") + params[:search][:'start_time(2i)'] + "-" + (params[:search][:'start_time(3i)'].length == 1? "0" : "") + params[:search][:'start_time(3i)'] + " 00:00:00"
	    params[:end_time] = params[:search][:'end_time(1i)'] + "-" + (params[:search][:'end_time(2i)'].length == 1? "0" : "") + params[:search][:'end_time(2i)'] + "-" + (params[:search][:'end_time(3i)'].length == 1? "0" : "") + params[:search][:'end_time(3i)'] + " 23:59:59"
	    if params[:applicant] != "" then
        user = User.find_by_realname(params[:applicant])
        user_id = 0 
        if user != nil then
          user_id = user.id
        end
        params[:serach_id] = user_id
	      if params[:app_type] == "所有" then
          @get_forms = Form.where("created_at >= :start_time and created_at <= :end_time and check_status = 4 and user_id = :search_id", :start_time => params[:start_time], :end_time => params[:end_time], :search_id => user_id)
      	else
      	  params[:search_type] = Form.get_search_tags[Form.get_search_type[params[:app_type]]]
      	  @get_forms = Form.where("created_at >= :start_time and created_at <= :end_time and app_type = :search_type and check_status = 4 and user_id = :search_id", :start_time => params[:start_time], :end_time => params[:end_time], :search_type => params[:search_type], :search_id => user_id)
      	end
      else
	      if params[:app_type] == "所有" then
          @get_forms = Form.where("created_at >= :start_time and created_at <= :end_time and check_status = 4", :start_time => params[:start_time], :end_time => params[:end_time])
      	else
      	  params[:search_type] = Form.get_search_tags[Form.get_search_type[params[:app_type]]]
      	  @get_forms = Form.where("created_at >= :start_time and created_at <= :end_time and app_type = :search_type and check_status = 4", :start_time => params[:start_time], :end_time => params[:end_time], :search_type => params[:search_type])
      	end
      end
      session[:form] = @get_forms
      session[:start_time] = params[:start_time]
      session[:end_time] = params[:end_time]
  	end
	end
end

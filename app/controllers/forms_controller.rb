# encoding: utf-8

class FormsController < ApplicationController

	def check_username
		if session[:current_user] == nil then
			flash[:notice] = "Login timed out!"
			if params[:ver] == 'ch' || params[:ver] == 'en'
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
	
	def empty_form_entry(entry)
		t = params[:form_entry][entry.to_s]
		return t == nil || t[:details] == "" && t[:amount] == ""
	end
	
	def valid_form_entry(entry)
		t = params[:form_entry][entry.to_s]
		if t[:details] == nil || t[:details] == "" then
			return false
		end
		if t[:amount] == nil || !t[:amount].match(/^(\d{1,12})(\.\d{0,2})?$/) then
			return false
		end
		return true
	end
	
	def new_form
		if check_username then return end
		@TOT_APPS = Form.TOT_APPS
		@current_user = User.find_by_user_name(session[:current_user][:username])
		if params[:commit] != nil then
			valid_form = true
			empty_form = true
			for i in 0..@TOT_APPS do
				if !empty_form_entry(i) then
					empty_form = false
					if !valid_form_entry(i) then
						valid_form = false
						flash[:debug] = params[:form_entry][i.to_s]
						break
					end
				end
			end	
			if !valid_form then
				flash[:notice] = params[:ver] == 'ch' ? "申请表填写错误，请重新填写":"Invalid Form, please fill again"
				redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			end
			if empty_form then
				flash[:notice] = params[:ver] == 'ch' ? "申请表不能为空，请重新填写":"Form should not be empty, please fill again"
				redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			end
			if params[:borrow] == 1 && !params[:borrow_amount].match(/^(\d{1,12})(\.\d{0,2})?$/) then
			  flash[:notice] = "已借款金额填写错误，请重新填写"
			  redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			end
			if !params[:receipts].match(/^(\d{1,12})(\.\d{0,2})?$/) then
			  flash[:notice] = params[:ver] == 'ch' ? "票据张数填写错误，请重新填写": "Receipt pages number invalid, please fill again"
			  redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			end
			other_info = "borrow(#{params[:borrow]}, #{params[:borrow_amount]}), receipts(#{params[:receipts]})"
			if params[:app_type] == "student" then
			  if params[:student_name] == nil || params[:student_name] == "" then
			    flash[:notice] = "姓名不能为空，请重新填写"
			    redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			  end
			  if params[:student_country] == nil || params[:student_name] == "" then
			    flash[:notice] = "国家/地区不能为空，请重新填写"
			    redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_form" and return
			  end
			  other_info = "#{other_info}, name(#{params[:student_name]}), country(#{params[:student_country]}), date(#{params[:student_date]})"
			end
			
			tot_amount = 0
			@app_form = Form.new
			for i in 0..@TOT_APPS do
				if !empty_form_entry(i) then
					entry_temp = params[:form_entry][i.to_s]
					amount = params[:form_entry][i.to_s][:amount].to_f
					tot_amount += amount
					@form_entry = App.create(:details => entry_temp[:details], :amount => amount, :pay_method => entry_temp[:pay_method])
					@app_form.apps << @form_entry
				end
			end
			@app_form.app_type = params[:app_type]
			@app_form.tot_amount = tot_amount
			@app_form.check_status = 0
			@app_form.otherinfo = other_info
			@app_form.save!
			@current_user.forms << @app_form
			redirect_to "/#{params[:ver]}/#{params[:current_user]}/apps" and return
		end
		# didn't commit, just render "new_application"
		render "new_application"
	end

end

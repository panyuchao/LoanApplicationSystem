class AppsController < ApplicationController

	def show
#		id = params[:id] # retrieve movie ID from URI route
		# will render app/views/movies/show.<extension> by default
	end

	def index
		if session[:current_user] == nil then
			flash[:notice] = "Login timed out!"
			redirect_to "/#{params[:ver]}/index" and return
		end
			
		@current_user = User.find_by_user_name(session[:current_user][:username])
		flash[:notice] = "#{@current_user.user_name}"
		if @current_user.is_admin then
			@apps_reim = App.find_all_by_app_type(0)
			@apps_loan = App.find_all_by_app_type(1)
			render "admin_show"
		else
			@apps_reim = App.find(:all, :conditions => {:app_type => 0, :applicant => @current_user.user_name})
			@apps_loan = App.find(:all, :conditions => {:app_type => 1, :applicant => @current_user.user_name})
			render "user_show"
		end
	end

	def new
		# default: render 'new' template
	end

	def new_app
		@app_type = params[:app_type]
		if session[:current_user] == nil then
			flash[:notice] = "Login timed out!"
			redirect_to "/#{params[:ver]}/index" and return
		end
		@current_user = User.find_by_user_name(session[:current_user][:username])
		if params[:commit] != nil && params[:app][:details] != '' then
			@app = App.create!(params[:app])
			@app.app_date = Time.new
			@app.applicant = session[:current_user][:username]
			@app.app_type = App.get_pay_methods[@app_type]
			@app.save!
			flash[:notice] = "Application successfully created."
			redirect_to "/#{params[:ver]}/#{params[:current_user]}/apps"
		else
			if params[:commit] != nil then
				flash[:notice] = "#{params[:app_type]}Details should not be empty!"
				#redirect_to "/#{params[:ver]}/#{params[:current_user]}/new_#{params[:app_type]}_app"
			end
		end
	end

	def edit
	end

	def update
	end

	def destroy
	end

end

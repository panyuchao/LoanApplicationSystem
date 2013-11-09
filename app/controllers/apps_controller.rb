class AppsController < ApplicationController

	def show
		id = params[:id] # retrieve movie ID from URI route
		# will render app/views/movies/show.<extension> by default
	end

	def index
		@apps_reim = App.find_all_by_app_type(0)
		@apps_loan = App.find_all_by_app_type(1)
	end

	def new
		# default: render 'new' template
	end

	def create
		if params[:app][:details] != '' then
			@app = App.create!(params[:app])
			@app.app_date = Time.new
			@app.app_type = 0
			@app.save!
			flash[:notice] = "Application successfully created."
		else
			flash[:notice] = "Details should not be empty!"
		end
		flash.keep
		redirect_to apps_path
	end

	def edit
	end

	def update
	end

	def destroy
	end

end

class AppsController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @apps = App.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @app = App.create!(params[:app])
    @app.application_date = Time.new
    @app.save!
    flash[:notice] = "Application successfully created."
    redirect_to apps_path
  end

  def edit
  end

  def update
  end

  def destroy
  end
	
end

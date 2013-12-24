class EnController < ApplicationController
  def index
		# just render 'index'
		if session[:current_user] != nil
			redirect_to "/en/#{session[:current_user][:username]}/apps" and return
                end
  end
  def show
#     @id = params[:id]
  end
  def apply
#     @id = params[:en_id]
  end
end

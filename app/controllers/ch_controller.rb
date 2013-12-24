# encoding: utf-8

class ChController < ApplicationController
	def index
		# just render 'index'
		if session[:current_user] != nil
			redirect_to "/ch/#{session[:current_user][:username]}/apps" and return
                end
	end
	def show
#		@id = params[:id]
	end
	def apply
#		@id = params[:ch_id]
	end
	def destroy
#		@flash[:notice]
#		render "
	end
end

class ChController < ApplicationController
  def index
  	flash[:notice] = "aaaaaaaaaaaaaaaaaaaa"
  end
  def show
     @id = params[:id]
  end
  def apply
     @id = params[:ch_id]
  end
end

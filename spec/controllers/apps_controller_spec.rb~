# encoding: utf-8

require 'spec_helper'

describe AppsController do
	describe 'list the applications' do
		it 'should redirect to home page if current_user is nil' do
			post :index, :ver => 'ch'
			response.should redirect_to "/ch/index"
		end
		it 'should render the admin view if current_user is an administrator' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username=>'admin'}
			post :index, :ver => 'ch'
			response.should render_template "admin_show"
		end
		it 'should render the user view if current_user is not an administrator' do
			current_user = mock('user', :user_name => 'user', :is_admin => false)
			User.should_receive(:find_by_user_name).with('user').and_return(current_user)
			session[:current_user] = {:username=>'user'}
			post :index, :ver => 'ch'
			response.should render_template "user_show"
		end	
	end
	
	describe 'create new applications' do
		it 'should redirect to home page if current_user is nil' do
			post :new_app, :ver => 'ch', :current_user => 'nil', :app_type => 'reim'
			response.should redirect_to "/ch/index"
		end
		it 'should get the current_user by user_name, save the application and redirect to show my apps page if the application is valid' do
			session[:current_user] = {:username => 'user'}
			current_user = mock('user', :user_name => 'user')
			User.should_receive(:find_by_user_name).with('user').and_return(current_user)
			app = mock('app', :details => 'details', :amount => '123', :pay_method => 0)
			App.should_receive(:create!).with({'details' => 'details', 'amount' => '123', 'pay_method' => '0'}).and_return(app)
			app.stub(:app_date=)
			app.stub(:applicant=)
			app.stub(:app_type=)
			app.stub(:save!)
			App.stub(:get_pay_methods).and_return({"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1})
			post :new_app, :ver => 'ch', :current_user => 'user', :app_type => 'reim', :commit => 'commit', :app => {:details => 'details', :amount => '123', :pay_method => 0}
			response.should redirect_to "/ch/user/apps"
		end
		it 'should stay on the page if details is empty, and leave a notice' do
			session[:current_user] = {:username => 'user'}
			post :new_app, :ver => 'ch', :current_user => 'user', :app_type => 'loan', :commit => 'commit', :app => {:details => ''}
			response.should render_template "new_app"
		end
	end	
end

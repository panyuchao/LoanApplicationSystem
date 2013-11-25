# encoding: utf-8

require 'spec_helper'

describe AppsController do
	describe 'list the applications' do
		it 'should redirect to home page if current_user is nil' do
			post :index, :ver => 'ch', :current_user => 'nil'
			response.should redirect_to "/ch/index"
		end
		it 'should render the admin view if current_user is an administrator' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username=>'admin'}
			post :index, :ver => 'ch', :current_user => 'admin'
			response.should render_template "admin_show"
		end
		it 'should render the user view if current_user is not an administrator' do
			current_user = mock('user', :user_name => 'user', :is_admin => false)
			User.should_receive(:find_by_user_name).with('user').and_return(current_user)
			session[:current_user] = {:username=>'user'}
			post :index, :ver => 'ch', :current_user => 'user'
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
			App.should_receive(:create!).with({'details' => 'details', 'amount' => '123.0', 'pay_method' => '0'}).and_return(app)
			app.stub(:app_date=)
			app.stub(:details=)
			app.stub(:applicant=)
			app.stub(:app_type=)
			app.stub(:check_status=)
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
	
	describe 'delete' do
		it 'delete test' do
			delist = mock('app')
#			App.should_receive(:find_by_create_at).with(:details).and_return(delist)
			session[:current_user] = {:username=>'user'}
			post :delete, :ver => 'ch', :details => '1'
			response.should redirect_to "/ch/user/apps"
		end
	end

	describe 'wait for verify' do
		it 'should redirect to home page if current_user is nil' do
			post :wait_for_verify, :ver => 'ch', :current_user => 'nil'
			response.should redirect_to "/ch/index"
		end
		it 'should render the wait_for_verify page if current_user is an administrator' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			post :wait_for_verify, :ver => 'ch', :current_user => 'admin'
			response.should render_template "wait_for_verify"
		end
		it 'should redirect to the user view page if current_user is not an administrator' do
			current_user = mock('user', :user_name => 'user', :is_admin => false)
			User.should_receive(:find_by_user_name).with('user').and_return(current_user)
			session[:current_user] = {:username=>'user'}
			post :wait_for_verify, :ver => 'ch', :current_user => 'user'
			response.should redirect_to "/ch/user/apps"
		end
	end
	
	describe 'changes' do
		it 'should redirect to home page if current_user is nil' do
			post :changes, :ver => 'ch', :id => '1', :current_user => 'nil'
			response.should redirect_to "/ch/index"
		end
		it 'should redirect to current page if it is a bad change' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			post :changes, :ver => 'ch', :current_user => 'admin', :s1 => '1', :s0 => '1', :id => '1'
			response.should redirect_to "/ch/admin/apps"
		end
		it 'should redirect to current page if the changed app is nil' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			app_now = mock('app')
			App.should_receive(:find).with('1')
			post :changes, :ver => 'ch', :current_user => 'admin', :s1 => '1', :s0 => '0', :id => '1'
			response.should redirect_to "/ch/admin/apps"
		end
		it 'should redirect to current page if the change is succeed' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			app_now = mock('app')
			App.should_receive(:find).with('1').and_return(app_now)
			app_now.stub(:check_status=)
			app_now.stub(:save!)
			post :changes, :ver => 'ch', :current_user => 'admin', :s1 => '1', :s0 => '0', :id => '1'
			response.should redirect_to "/ch/admin/apps"
		end
	end
	
	describe 'reviewed' do
		it 'should redirect to home page if current_user is nil' do
			post :reviewed, :ver => 'ch', :current_user => 'nil'
			response.should redirect_to "/ch/index"
		end
		it 'should render the admin reviewed page if current is an asministrator' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			get_apps = mock('apps')
			App.should_receive(:find).with(:all, :conditions => {:check_status => [3,4]}).and_return(get_apps)
			stub(:check_status_num=)
			post :reviewed, :ver => 'ch', :current_user => 'admin'
			response.should render_template "admin_reviewed"
		end
	end
end

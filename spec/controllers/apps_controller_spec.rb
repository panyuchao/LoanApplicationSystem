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
			apps = [mock('form'), mock('form')]
			current_user.should_receive(:forms).and_return(apps)
			post :index, :ver => 'ch', :current_user => 'user'
			response.should render_template "user_show"
		end
	end
	
	describe 'delete' do
		it 'should delete the specified application' do
			app = mock('app')
#			App.should_receive(:find_by_create_at).with(:details).and_return(delist)
			App.should_receive(:all).and_return([app])
			app.stub(:created_at).and_return("20131208204256")
			app.stub(:[]).with(:applicant).and_return('user')
			session[:current_user] = {:username=>'user'}
			session[:is_admin] = true
			App.should_receive(:destroy).with(app)
			post :delete, :ver => 'ch', :details => "20131208204256"
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
		it 'should redirect to default apps page if current user is not admin' do
			current_user = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(current_user)
			current_user.stub(:is_admin).and_return(true)
			session[:current_user] = {:username => 'test'}
			post :changes, :ver => 'ch', :id => '1', :current_user => 'test'
			response.should redirect_to "/ch/test/apps"
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
			form_now = mock('form')
			Form.should_receive(:find).with('1')
			post :changes, :ver => 'ch', :current_user => 'admin', :s1 => '1', :s0 => '0', :id => '1'
			response.should redirect_to "/ch/admin/apps"
		end
		it 'should redirect to current page if the change succeeds' do
			current_user = mock('user', :user_name => 'admin', :is_admin => true)
			User.should_receive(:find_by_user_name).with('admin').and_return(current_user)
			session[:current_user] = {:username => 'admin'}
			form_now = mock('form')
			Form.should_receive(:find).with('1').and_return(form_now)
			form_now.stub(:check_status=)
			form_now.stub(:save!)
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
			get_forms = mock('forms')
			Form.should_receive(:find).with(:all, :conditions => {:check_status => [3,4]}).and_return(get_forms)
			post :reviewed, :ver => 'ch', :current_user => 'admin'
			response.should render_template "admin_reviewed"
		end
	end
end

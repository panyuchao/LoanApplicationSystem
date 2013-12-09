

require 'spec_helper'

describe UserController do
	describe 'login' do
		it 'should refresh the session hash and redirect to list apps view if username/password pair is valid' do
			current_user = mock('user')
			User.should_receive(:find_by_user_name).with('user').and_return(current_user)
			current_user.stub(:user_pass).and_return('password')
			current_user.stub(:is_admin).and_return(false)
			current_user.stub(:user_name).and_return('user')
			post :login, :ver => 'ch', :user => {:username => 'user', :password => 'password'}
			response.should redirect_to "/ch/user/apps"
		end
		it 'should redirect to homepage if username/password pair is invalid' do
			current_user = mock('user')
			User.should_receive(:find_by_user_name).with('user').and_return(nil)
			post :login, :ver => 'ch', :user => {:username => 'user', :password => 'password'}
			response.should redirect_to "/ch/index"
		end
	end
	describe 'logout' do
		it 'should clean the session hash of :current_user and :is_admin, leave a notice and redirect to homepage' do
			session[:current_user].should == nil
			session[:is_admin].should == nil
			post :logout, :current_user => 'user', :ver => 'ch'
			response.should redirect_to "/ch/index"
		end
	end
	
	describe 'user management' do
		it 'should delete the specified user and his applications if current user has privilege' do
			delist = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(delist)
			session[:is_admin] = true
			delist.stub(:[]).with(:is_admin).and_return(false)
			session[:current_user] = {:username => 'test'}
			User.should_receive(:destroy).with(delist)
			post :remove, :ver => 'ch', :user_name => 'test'
			response.should redirect_to "/ch/test/user_management"
		end

		it 'should not delete user if current user has no privilege' do
			delist = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(delist)
			session[:is_admin] = false
			delist.stub(:[]).with(:is_admin).and_return(false)
			session[:current_user] = {:username => 'test'}
			post :remove, :ver => 'ch', :user_name => 'test'
			response.should redirect_to "/ch/test/user_management"
		end		
	end
end

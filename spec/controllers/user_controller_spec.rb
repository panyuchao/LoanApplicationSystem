

require 'spec_helper'

describe UserController do
	describe 'login' do
		it 'should redirect to homepage if no username&password is typed in' do
			post :login, :ver => 'ch'
			response.should redirect_to "/ch/index"
		end
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
end

require 'spec_helper'

describe FormsController do
	describe 'new application form page' do
		it 'should redirect to home page if current user is nil' do
			post :new_form, :ver => 'ch', :current_user => 'test', :app_type => 'reim'
			response.should redirect_to '/ch/index'
		end
		
		it 'should redirect to ch home page if current user is nil and no language specified in params hash' do
			post :new_form, :ver => '', :current_user => 'test', :app_type => 'reim'
			response.should redirect_to '/ch/index'
		end
		
		it "should redirect to the default user show page of current user if username in params hash doesn\'t match current user in session hash" do
			session[:current_user] = {:username => 'test1'}
			post :new_form, :ver => 'ch', :current_user => 'test2', :app_type => 'reim'
			response.should redirect_to '/ch/test1/apps'
		end
		
		it 'should render new_form if the action is first called' do
			session[:current_user] = {:username => 'test'}
			current_user = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(current_user)
			post :new_form, :ver => 'ch', :current_user => 'test', :app_type => 'reim'
			response.should render_template "new_form"
		end
		
		it 'should redirect to new application page if the form is invalid' do
			session[:current_user] = {:username => 'test'}
			current_user = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(current_user)
			form_entry = {'1' => {:details => "details", :amount => 'abc'}}
			post :new_form, :ver => 'ch', :current_user => 'test', :app_type => 'reim', :commit => true, :form_entry => form_entry
			response.should redirect_to '/ch/test/new_reim_form'
		end
			
		it 'should redirect to new application page if the from is empty' do
			session[:current_user] = {:username => 'test'}
			current_user = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(current_user)
			form_entry = {}
			post :new_form, :ver => 'ch', :current_user => 'test', :app_type => 'reim', :commit => true, :form_entry => form_entry
			response.should redirect_to '/ch/test/new_reim_form'
		end
		
		it 'should save the application form if the form is valid' do
			session[:current_user] = {:username => 'test'}
			current_user = mock('user', :user_name => 'test')
			User.should_receive(:find_by_user_name).with('test').and_return(current_user)
			app_form = mock('form')
			Form.should_receive(:new).and_return(app_form)
			app_form.stub(:apps).and_return([])
			app_form.stub(:applicant=)
			app_form.stub(:app_type=)
			app_form.stub(:tot_amount=)
			app_form.stub(:check_status=)
			app_form.stub(:save!)
			current_user.stub(:forms).and_return([])
			form_entry = {'1' => {:details => "details", :amount => '100'}}
			post :new_form, :ver => 'ch', :current_user => 'test', :app_type => 'reim', :commit => true, :form_entry => form_entry
			response.should redirect_to '/ch/test/apps'
		end
	end
end

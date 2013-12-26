# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

test_apps1 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps2 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2012', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2013', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2012', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2013', :pay_method => "银行卡"},
		  	]

test_users = [{:user_name => 'test_user1', :user_pass => 'pass', :is_admin => false, :email => 'test_user001@163.com'},
			  {:user_name => 'test_user2', :user_pass => 'pass', :is_admin => false},
			  {:user_name => 'test_user3', :user_pass => 'pass', :is_admin => false},
			  {:user_name => 'admin', :user_pass => 'admin', :is_admin => true, :email => 'test_admin001@163.com'}
			 ] 

test_form1 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0)
test_form1.save!

test_form2 = Form.new(:applicant => 'test_user2', :app_type => 'loan', :check_status => 0)
test_form2.save!

test_apps1.each do |x|
  app = App.create!(x)
  test_form1.apps << app
end

test_apps2.each do |x|
  app = App.create!(x)
  test_form2.apps << app
end

test_users.each do |x|
	User.create!(x)
end

test_user_1 = User.find_by_user_name('test_user1')
test_user_1.forms << test_form1
test_user_2 = User.find_by_user_name('test_user2')
test_user_2.forms << test_form2



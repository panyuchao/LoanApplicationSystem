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

test_apps3 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps4 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps5 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps6 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps7 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps8 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps9 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_apps10 = [  {:details => 'test003', :amount => 13942, :created_at => '21-Jul-2011', :pay_method => "现金"},
			  	  {:details => 'test004', :amount => 3233, :created_at => '10-Aug-2012', :pay_method => "汇款"},
				  {:details => 'test005', :amount => 534442, :created_at => '27-Jul-2011', :pay_method => "支票"},
			  	  {:details => 'test006', :amount => 78293, :created_at => '23-Aug-2012', :pay_method => "银行卡"},
		  	]

test_users = [{:user_name => 'test_user1', :user_pass => 'pass', :is_admin => false, :email => 'test_user001@163.com'},
			  {:user_name => 'test_user2', :user_pass => 'pass', :is_admin => false},
			  {:user_name => 'test_user3', :user_pass => 'pass', :is_admin => false},
			  {:user_name => 'admin', :user_pass => 'admin', :is_admin => true, :email => 'test_admin001@163.com'}
			 ] 

test_form1 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form1.save!

test_form2 = Form.new(:applicant => 'test_user2', :app_type => 'loan', :check_status => 0, :tot_amount => 0)
test_form2.save!

test_form3 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form3.save!

test_form4 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form4.save!

test_form5 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form5.save!

test_form6 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form6.save!

test_form7 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form7.save!

test_form8 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form8.save!

test_form9 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form9.save!

test_form10 = Form.new(:applicant => 'test_user1', :app_type => 'reim', :check_status => 0, :tot_amount => 0)
test_form10.save!

test_apps1.each do |x|
  app = App.create!(x)
  test_form1.apps << app
  test_form1.tot_amount = test_form1.tot_amount + x[:amount]
end
test_form1.save!

test_apps2.each do |x|
  app = App.create!(x)
  test_form2.apps << app
  test_form2.tot_amount = test_form2.tot_amount + x[:amount]
end
test_form2.save!

test_apps3.each do |x|
  app = App.create!(x)
  test_form3.apps << app
  test_form3.tot_amount = test_form3.tot_amount + x[:amount]
end
test_form3.save!

test_apps4.each do |x|
  app = App.create!(x)
  test_form4.apps << app
  test_form4.tot_amount = test_form4.tot_amount + x[:amount]
end
test_form4.save!

test_apps5.each do |x|
  app = App.create!(x)
  test_form5.apps << app
  test_form5.tot_amount = test_form5.tot_amount + x[:amount]
end
test_form5.save!

test_apps6.each do |x|
  app = App.create!(x)
  test_form6.apps << app
  test_form6.tot_amount = test_form6.tot_amount + x[:amount]
end
test_form6.save!

test_apps7.each do |x|
  app = App.create!(x)
  test_form7.apps << app
  test_form7.tot_amount = test_form7.tot_amount + x[:amount]
end
test_form7.save!

test_apps8.each do |x|
  app = App.create!(x)
  test_form8.apps << app
  test_form8.tot_amount = test_form8.tot_amount + x[:amount]
end
test_form8.save!

test_apps9.each do |x|
  app = App.create!(x)
  test_form9.apps << app
  test_form9.tot_amount = test_form9.tot_amount + x[:amount]
end
test_form9.save!

test_apps10.each do |x|
  app = App.create!(x)
  test_form10.apps << app
  test_form10.tot_amount = test_form10.tot_amount + x[:amount]
end
test_form10.save!

test_users.each do |x|
	User.create!(x)
end

test_user_1 = User.find_by_user_name('test_user1')
test_user_1.forms << test_form1
test_user_2 = User.find_by_user_name('test_user2')
test_user_2.forms << test_form2
test_user_1.forms << test_form3
test_user_1.forms << test_form4
test_user_1.forms << test_form5
test_user_1.forms << test_form6
test_user_1.forms << test_form7
test_user_1.forms << test_form8
test_user_1.forms << test_form9
test_user_1.forms << test_form10



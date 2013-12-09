# encoding: utf-8
require 'spec_helper'

describe User do	
	describe 'get user tags' do
		it 'should return all user tags' do
			User.get_user_tags.should == [ ["总览", "Overview", "apps"] ]
		end
	end
	
	describe 'get new application tags of user' do
		it 'should return all new application tags' do
			User.get_user_new_tags.should ==  [ ["报销申请", "Reimbursement", "new_reim_form"], ["借款申请", "Loan", "new_loan_form"] ]
		end
	end
	
	describe 'get the table header of user show view' do
		it 'should return all table headers' do
			User.get_user_show_th.should ==  [["展开", "+", 5], ["编号", "ID", 5], ["申请时间", "Time", 25], ["申请类型", "Application Type", 20], ["总金额", "Total Amount", 20], ["处理结果", "Result", 15], ["撤销", "Cancel", 10]]
		end
	end	
end

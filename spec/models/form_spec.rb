# encoding: utf-8
require 'spec_helper'

describe Form do
	describe 'get total number of form entries' do
		it 'should return 7' do
			Form.TOT_APPS.should == 7
		end
	end
	
	describe 'get all the application types' do
		it 'should return application types in a hash' do
			Form.get_app_type.should ==  {"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
		end
	end
	 
	describe 'get all the check status names' do
		it 'should return all the names of check status' do
			Form.get_check_tags.should ==  [ ["未审核", "0"], ["正在审核中", "1"], ["正在审核中", "2"], ["已通过审核", "3"], ["未通过审核", "4"] ]
		end
	end
	
	describe 'get the table headers of application form' do
		it 'should return all the table header names plus width' do 
			Form.get_reim_th.should == [["序号", "ID", 4], ["内容", "Details", 69], ["金额", "Amount", 12], ["报销方式", "Pay method", 15]]
		end
	end
end

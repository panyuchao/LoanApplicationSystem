# encoding: utf-8

require 'spec_helper'

describe App do
	describe 'get all pay methods' do
		it 'should return all pay methods' do
			App.get_pay_methods.should == {"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
		end
	end
end

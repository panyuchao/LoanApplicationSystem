# encoding: utf-8

class App < ActiveRecord::Base
	def self.get_pay_methods
		{"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
	end
	
	def self.take_pay_methods
		["报销", "借款", "reim", "loan"]
	end
	
	def self.get_admin_tags
	  ["未审核", "待确认", "已审核"]
	end
end

# encoding: utf-8

class App < ActiveRecord::Base
	belongs_to :form

	
	def self.take_pay_methods
		["报销", "借款", "reim", "loan"]
	end
	
	def self.get_admin_tags
		[ ["未审核", "apps"], ["待确认", "wait_for_verify"], ["已审核", "reviewed"] ]
	end
	
	def self.get_user_tags
	  [ ["总览", "apps"] ]
	end
	
	def self.get_user_new_tags
	  [ ["报销申请", "new_reim_form"], ["借款申请", "new_loan_form"] ]
	end
	
	def self.get_check_status_num
		@admin_tags = []
		get_admin_tags.each do |x|
			@admin_tags << x[0]
		end
		@check_status_num = {}
		@admin_tags.each do |x|
			@check_status_num[x] = 0
		end

		@all_apps = App.all
		if @all_apps != nil then
			@all_apps.each do |x|
				if x.check_status != nil then
					@check_status_num[@admin_tags[(x.check_status+1)>>1]] += 1
				end
			end
		end
		return @check_status_num
	end
end

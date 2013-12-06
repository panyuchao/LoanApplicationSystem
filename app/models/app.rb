# encoding: utf-8

class App < ActiveRecord::Base
	belongs_to :form
	
	def self.get_user_tags
	  [ ["总览", "apps"] ]
	end
	
	def self.get_user_new_tags
	  [ ["报销申请", "new_reim_form"], ["借款申请", "new_loan_form"] ]
	end
end

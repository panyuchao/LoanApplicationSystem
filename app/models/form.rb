# encoding: utf-8

class Form < ActiveRecord::Base
	has_many :apps
	belongs_to :user
	
	def self.TOT_APPS
		7
	end

	def self.get_app_type
		{"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
	end	
end

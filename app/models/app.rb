# encoding: utf-8

class App < ActiveRecord::Base
	def self.get_app_type
		{"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
	end
end

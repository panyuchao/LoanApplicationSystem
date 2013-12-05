class Form < ActiveRecord::Base
	has_many :apps
	belongs_to :user
	def self.TOT_APPS
		7
	end
end

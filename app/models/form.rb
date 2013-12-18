# encoding: utf-8

class Form < ActiveRecord::Base
	has_many :apps, :dependent => :destroy
	belongs_to :user
	
	def self.TOT_APPS
		7
	end

	def self.get_app_type
		{"报销" => 0, "借款" => 1, "reim" => 0, "loan" => 1}
	end

	def self.get_admin_tags
		[ ["未审核", "apps"], ["待确认", "wait_for_verify"], ["已审核", "reviewed"] ]
	end
	
	def self.get_check_tags
	  [ ["未审核", "0"], ["正在审核中", "1"], ["正在审核中", "2"], ["已通过审核", "3"], ["未通过审核", "4"] ]
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

		@all_forms = Form.all
		if @all_forms != nil then
			@all_forms.each do |x|
				if x.check_status != nil then
					@check_status_num[@admin_tags[(x.check_status+1)>>1]] += 1
				end
			end
		end
		return @check_status_num
	end
	
	def self.get_reim_th
	  [["序号", "ID", 4], ["内容", "Details", 69], ["金额", "Amount", 12], ["报销方式", "Pay method", 15]]
	end

	def self.get_pdf_th
		[["序号",7], ["内容",38], ["申请人",12], ["申请时间",15], ["金额",12], ["报销方式",16]]
	end
end

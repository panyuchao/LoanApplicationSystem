# encoding: utf-8

class Form < ActiveRecord::Base
	has_many :apps, :dependent => :destroy
	belongs_to :user
	
	def self.TOT_APPS
		7
	end

  def self.get_app_tags
    [["财务 报销单", "Reimbursement"], ["财务 借款单", "Loan Application"], ["学生出访/会议 报销单", "Student"]]
  end

	def self.get_app_type
		{"报销" => 0, "reim" => 0, "借款" => 1, "loan" => 1, "学生" => 2, "student" => 2}
	end

	def self.get_admin_tags
		[ ["未审核", "apps"], ["待确认", "wait_for_verify"], ["未通过审核", "failed_to_verify"], ["已通过审核", "reviewed"], ["已结束的申请", "ended_apps"] ]
	end
	
	def self.get_check_tags
	  [ ["未审核", "0"], ["正在审核中", "1"], ["未通过审核", "2"], ["等待领款", "3"], ["已结束审核", "4"] ]
	end
	
	def self.get_change_status
	  [ [0, 1], [0, 2], [1, 2], [1, 3], [3, 4] ]
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
					@check_status_num[@admin_tags[x.check_status]] += 1
				end
			end
		end
		return @check_status_num
	end
	
	def self.get_reim_th
	  [["序号", "ID", 4], ["内容", "Details", 69], ["金额", "Amount", 12], ["报销方式", "Pay method", 15]]
	end
	
	def self.tot_student_details
	  8
	end
	
	def self.get_student_details
	  ["机票/火车票", "签证费", "北京市内交通", "注册费", "驻地城间交通", "住宿费", "生活费", "其它"]
	end

	def self.get_pdf_th
		[["序号",7], ["内容",38], ["申请人",12], ["申请时间",15], ["金额",12], ["报销方式",16]]
	end
	
	def self.get_pay_method_tags
	  [["现金", "Cash"], ["支票", "Cheque"], ["汇款", "Bank"], ["银行卡", "Card"]]
	end
	
	def self.get_pay_method_type
		{"现金" => 0, "Cash" => 0, "支票" => 1, "Cheque" => 1, "汇款" => 2, "Bank" => 2, "银行卡" => 3, "Card" => 3}
	end
	
	def self.get_form_tags
	  [["序号", "id"], ["内容", "details"], ["金额", "amount"], ["报销方式", "pay method"], ["帐号", "account number"]]
	end
end

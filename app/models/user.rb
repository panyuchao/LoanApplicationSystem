# encoding: utf-8

class User < ActiveRecord::Base
  # attr_accessible :title, :body
	has_many :forms, :dependent => :destroy

	def self.get_user_tags
	  [ ["总览", "Overview", "apps"] ]
	end
	
	def self.get_user_new_tags
	  [ ["报销申请", "Reimbursement", "new_reim_form"], ["借款申请", "Loan", "new_loan_form"] ]
	end

  def self.get_user_show_th
    [["展开", "+", 5], ["编号", "ID", 5], ["申请时间", "Time", 25], ["申请类型", "Application Type", 20], ["总金额", "Total Amount", 20], ["处理结果", "Result", 15], ["撤销", "Cancel", 10]]
  end
end

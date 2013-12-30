# encoding: utf-8
require 'csv'
require "prawn"

class App < ActiveRecord::Base
	belongs_to :form
	  #attr_accessible :details,:amount,:pay_method,:account_num,:form_id
=begin  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |app|
        csv << app.attributes.values_at(*column_names)
      end
    end
  end
=end  
  def self.to_pdf(forms, start_time, end_time)
  	page = 1
  	left = 20
  	right = 530
  	xlen = right-left
  	top = 730
  	height = 18
  	padding = 3
  	pdf = Prawn::Document.new
  	pdf.font_families.update("Sim Hei"=>{:normal =>"app/assets/fonts/simhei.ttf"})
		pdf.font "Sim Hei"
		
		pdf.text_box "清华大学交叉信息学院财务 报销/借款 审核汇总", :size => 22, :at => [left, top+5], :width => 500, :align => :center
		start_time = start_time.split(" ")[0].split("-")
		end_time = end_time.split(" ")[0].split("-")	
		format = ["年", "月", "日"]
		tstart = ""; tend = ""
		for i in 0..2 do
		  tstart = tstart + start_time[i] + format[i]
		  tend = tend + end_time[i] + format[i]
		end
		pdf.text_box "(#{tstart} 至 #{tend})", :size => 14, :at => [left+120, top-23], :width => 500, :align => :center
  	current_height = top - 30
  	title = "清华大学交叉信息研究院"
  	type_title = ["报销方式", "支付方式"]
  	pay_method = ["现", "支", "汇", "卡"]
  	all_titles = Form.get_app_tags
  	app_type_num = [4, 3]
  	column_width_tot = []
  	column_width_sum_tot = []
  	app_type_num.each do |x|
    	column_width = [6, 4, 40, 15, x*5, 15+(4-x)*5]
    	column_width = column_width.each.map{|x| x*xlen/100}
    	column_width_sum = []
    	for i in 0..4 do
    	  column_width_sum[i] = column_width[i]
    	  column_width_sum[i] += column_width_sum[i-1] unless i == 0
    	end
    	column_width_tot << column_width
    	column_width_sum_tot << column_width_sum
    end
    # for student
    height_student = 11*height/9
    width_student = [12, 14, 14, 16, 20, 24]
    width_student = width_student.each.map{ |x| x*xlen/100 }
    width_student_sum = []
    for i in 0..5 do
      width_student_sum[i] = width_student[i]
      width_student_sum[i] += width_student_sum[i-1] unless i == 0
    end
    student_details = Form.get_student_details
    
		forms.each do |form|
		  app_type = Form.get_app_type[form.app_type]
		  column_width = column_width_tot[app_type]
		  column_width_sum = column_width_sum_tot[app_type]
		  if current_height - 11*height < 10 then
		    pdf.start_new_page
		    current_height = top
		  end
		  pdf.text_box "#{title}#{all_titles[app_type][0]}", :size => 16, :at => [left, current_height-height+5], :width => 500, :align => :center
		  current_height -= 2*height
		  
		  if app_type == 2 then
		    pdf.stroke_line([left, current_height], [right, current_height])
		    form.otherinfo.match(/name\((.*?)\), country\((.*?)\), date\((.*?)\)/)
		    pdf.text_box "姓\s名", :at => [left, current_height-5], :width => width_student[0], :align => :center
		    pdf.text_box "#{$1}", :at => [left+width_student[0], current_height-5], :width => width_student[1], :align => :center
		    pdf.text_box "国家\/地区", :at => [left+width_student_sum[1], current_height-5], :width => width_student[2], :align => :center
		    pdf.text_box "#{$2}", :at => [left+width_student_sum[2], current_height-5], :width => width_student[3], :align => :center
		    pdf.text_box "出访日期", :at => [left+width_student_sum[3], current_height-5], :width => width_student[4], :align => :center
		    pdf.text_box "#{$3}", :at => [left+width_student_sum[4], current_height-5], :width => width_student[5], :align => :center
		    for i in 0..4 do 
  		    pdf.stroke_line([left+width_student_sum[i], current_height], [left+width_student_sum[i], current_height-height_student])
		    end
		    current_height -= height_student
		    pdf.stroke_line([left, current_height], [right, current_height])
		    pdf.stroke_line([left+xlen/2, current_height], [left+xlen/2, current_height-5*height_student])
		    pdf.stroke_line([left+width_student_sum[1], current_height], [left+width_student_sum[1], current_height-5*height_student])
		    pdf.stroke_line([left+width_student_sum[4], current_height], [left+width_student_sum[4], current_height-6*height_student])
		    
		    pdf.text_box "事\s项", :at => [left, current_height-5], :width => width_student[0]+width_student[1], :align => :center
		    pdf.text_box "金\s额", :at => [left+width_student_sum[1], current_height-5], :width => width_student[5], :align => :center
		    pdf.text_box "事\s项", :at => [left+xlen/2, current_height-5], :width => width_student[0]+width_student[1], :align => :center
		    pdf.text_box "金\s额", :at => [left+width_student_sum[4], current_height-5], :width => width_student[5], :align => :center
		    current_height -= height_student
		    apps = form.apps
		    for i in 1..4 do
		      pdf.stroke_line([left, current_height], [right, current_height])
		      pdf.text_box "#{i}", :at => [left, current_height-5], :width => 6*xlen/100, :align => :center
		      pdf.text_box "#{i+4}", :at => [left+width_student_sum[3]-6*xlen/100, current_height-5], :width => 6*xlen/100, :align => :center
		      pdf.text_box "#{student_details[i-1]}", :at => [left+6*xlen/100, current_height-5], :width => width_student[4], :align => :center
		      pdf.text_box "#{student_details[i+4-1]}", :at => [left+width_student_sum[3], current_height-5], :width => width_student[4], :align => :center
		      pdf.text_box "#{apps[i-1].amount}", :at => [left+width_student_sum[1], current_height-5], :width => width_student[5], :align => :center
		      pdf.text_box "#{apps[i+4-1].amount}", :at => [left+width_student_sum[4], current_height-5], :width => width_student[5], :align => :center
		      current_height -= height_student
		    end
		    pdf.stroke_line([left, current_height], [right, current_height])
		    pdf.stroke_line([left+6*xlen/100, current_height], [left+6*xlen/100, current_height+4*height_student])
		    pdf.stroke_line([left+width_student_sum[3], current_height], [left+width_student_sum[3], current_height+4*height_student])
		    pdf.stroke_line([left+width_student_sum[0], current_height], [left+width_student_sum[0], current_height-height_student])
	      pdf.text_box "合\s计", :at => [left, current_height-5], :width => width_student[0], :align => :center
	      pdf.text_box "#{form.tot_amount}", :at => [left+width_student_sum[0], current_height-5], :width => width_student_sum[3]-width_student[0], :align => :center
		    pdf.stroke_line([left+width_student_sum[3], current_height], [left+width_student_sum[3], current_height-height_student])
	      pdf.text_box "账\s号", :at => [left+width_student_sum[3], current_height-5], :width => width_student[4], :align => :center
	      pdf.text_box "#{form.apps[0].account_num}", :at => [left+width_student_sum[4], current_height-5], :width => width_student[5], :align => :center
	      current_height -= height_student
		    pdf.stroke_line([left, current_height], [right, current_height])
		    pdf.stroke_line([left, current_height+7*height_student], [left, current_height-2*height_student])
		    pdf.stroke_line([right, current_height+7*height_student], [right, current_height-2*height_student])
		    
		    pdf.text_box "申请人:\s#{form.user.realname != nil ? form.user.realname: form.user.user_name}", :at => [left+width_student_sum[3]-10*xlen/100, current_height-5], :width => 30*xlen/100
		    pdf.text_box "日期:\s#{form.created_at.strftime("%Y-%m-%d")}", :at => [left+width_student_sum[4], current_height-5], :width => width_student[5]
		    form.otherinfo.match(/^borrow\((.*?), (.*?)\), receipts\((.*?)\)/)
	      pdf.text_box "是否有借款:\s□是\s□否", :at => [left+width_student_sum[0]-3, current_height-5-height], :width => width_student_sum[3]
	      if $1 == '1' then
	        pdf.text_box "√\s\s\s\s\s\s\s\s\s\s\s金额:\s#{$2}", :at => [left+width_student_sum[0]+68, current_height-5-height], :width => width_student_sum[3]
	      else
	        pdf.text_box "√", :at => [left+width_student_sum[0]+98, current_height-5-height], :width => width_student_sum[3]
	      end
	      pdf.text_box "附票据张数: #{$3}", :at => [left+width_student_sum[3]+10*xlen/100, current_height-5-height], :width => width_student[5]+width_student[0]
	      
	      current_height -= 2*height_student
		    pdf.stroke_line([left, current_height], [right, current_height])
# end of make student form		    
		  else
		    pdf.stroke_line([left, current_height], [right, current_height])
		    
		    pdf.text_box "内\s容", :at => [left+column_width_sum[1], current_height-12], :width => column_width[2], :align => :center
		    pdf.text_box "金\s额", :at => [left+column_width_sum[2], current_height-12], :width => column_width[3], :align => :center
		    pdf.text_box "账\s号", :at => [left+column_width_sum[4], current_height-12], :width => column_width[5], :align => :center
		    pdf.text_box "序号", :at => [left+column_width_sum[0], current_height-5], :width => column_width[1], :align => :center
		    pdf.text_box "摘", :at => [left+1*xlen/100, current_height-3*height-10], :width => column_width[0]-2*xlen/100, :align => :center
		    pdf.text_box "要", :at => [left+1*xlen/100, current_height-5*height+4], :width => column_width[0]-2*xlen/100, :align => :center
		    pdf.stroke_line([left+column_width_sum[3], current_height-height], [left+column_width_sum[4], current_height-height])
		    pdf.text_box "#{type_title[app_type]}", :at => [left+column_width_sum[3], current_height-2], :width => column_width[4], :align => :center
		    for i in 1..app_type_num[app_type] do
		      pdf.text_box "#{pay_method[i-1]}", :at => [left+column_width_sum[3]+5*xlen/100*(i-1), current_height-height-2], :width => 5*xlen/100, :align => :center
		      pdf.stroke_line([left+column_width_sum[3]+5*xlen/100*(i-1), current_height-height], [left+column_width_sum[3]+5*xlen/100*(i-1), current_height-9*height])
		    end
		    
		    
		    current_height -= 2*height
		    
		    for i in 1..7 do
		      pdf.stroke_line([left+column_width[0], current_height], [right, current_height])
		      pdf.text_box "#{i}", :at => [left+column_width[0], current_height-2], :width => column_width[1], :align => :center
		      current_height -= height
		    end
		    pdf.stroke_line([left, current_height], [right, current_height])
		    column_width_sum.each do |x|
		      pdf.stroke_line([left+x, current_height], [left+x, current_height + 9*height])
		    end
		    
		    current_height -= 2*height
		    pdf.stroke_line([left, current_height], [right, current_height])
		    pdf.stroke_line([left, current_height], [left, current_height + 11*height])
		    pdf.stroke_line([right, current_height], [right, current_height + 11*height])
		    
		    current_height += 9*height
		    current_height_temp = current_height
		    form.apps.each do |app|
		      pdf.text_box "#{app.details}", :at => [left+column_width_sum[1], current_height-3], :width => column_width[2], :align => :center
		      pdf.text_box "#{app.amount}", :at => [left+column_width_sum[2], current_height-3], :width => column_width[3], :align => :center
		      pdf.text_box "#{app.account_num}", :size => 8, :at => [left+column_width_sum[4], current_height-5], :width => column_width[5], :align => :center
		      pdf.text_box "√", :at => [left+column_width_sum[3]+Form.get_pay_method_type[app.pay_method]*5*xlen/100, current_height-3], :width => 5*xlen/100, :align => :center
		      current_height -= height
		    end
		    current_height = current_height_temp - 7*height
		    if app_type == 0 then
		      pdf.text_box "申请人:\s#{form.user.realname != nil ? form.user.realname: form.user.user_name}", :at => [left+column_width_sum[2], current_height-2], :width => column_width[3]+column_width[4]
		      pdf.text_box "日期:\s#{form.created_at.strftime("%Y-%m-%d")}", :at => [left+column_width_sum[3]+16*xlen/100, current_height-2], :width => column_width[5]+column_width[0]
		      form.otherinfo.match(/^borrow\((.*?), (.*?)\), receipts\((.*?)\)/)
		      pdf.text_box "是否有借款:\s□是\s□否", :at => [left+column_width_sum[1]-3, current_height-2-height], :width => column_width_sum[2]
		      if $1 == '1' then
		        pdf.text_box "√\s\s\s\s\s\s\s\s\s\s\s金额:\s#{$2}", :at => [left+column_width_sum[1]+68, current_height-2-height], :width => column_width_sum[2]
		      else
		        pdf.text_box "√", :at => [left+column_width_sum[1]+98, current_height-2-height], :width => column_width_sum[2]
		      end
		      pdf.text_box "附票据张数: #{$3}", :at => [left+column_width_sum[3]+11*xlen/100, current_height-2-height], :width => column_width[5]+column_width[0]
		    else
		      pdf.text_box "申请人:\s#{form.user.realname != nil ? form.user.realname: form.user.user_name}", :at => [left+column_width_sum[2], current_height-height-2], :width => column_width[3]+column_width[4]
		      pdf.text_box "日期:\s#{form.created_at.strftime("%Y-%m-%d")}", :at => [left+column_width_sum[3]+16*xlen/100, current_height-height-2], :width => column_width[5]+column_width[0]
		    end
		    current_height -= 2*height
		  end
		  current_height -= 16
		end
		
		
=begin		
		pdf.stroke_line([left, top], [right, top])
		apps.each do |app|
			pdf.stroke_line([left, top-count*height], [right, top-count*height])
			pdf.text_box "#{app.id}", :at => [left, top-count*height-padding], :width => 7*xlen/100, :align => :center
			pdf.text_box "#{app.details}", :at => [left+7*xlen/100, top-count*height-padding], :width => 38*xlen/100, :align => :center
			pdf.text_box "#{app.created_at.strftime("%x")}", :at => [left+57*xlen/100, top-count*height-padding], :width => 15*xlen/100, :align => :center
			pdf.text_box "#{app.amount}", :at => [left+72*xlen/100, top-count*height-padding], :width => 12*xlen/100, :align => :center
			count += 1
			if count > 33 then
		    pdf.stroke_line([left, top-count*height], [right, top-count*height])
		    pdf.stroke_line([left, top], [left, top-count*height])
		    pdf.stroke_line([right, top], [right, top-count*height])
				count = 1
				pdf.start_new_page
			end
		end
		left_now = left
		Form.get_pdf_th.each do |x|
			pdf.text_box "#{x[0]}", :at => [left_now, top-5], :width => x[1]*xlen/100, :align => :center
			pdf.stroke_line([left_now, top], [left_now, top-count*height])
			left_now += x[1]*xlen/100
		end
=end		
		pdf.render_file "output.pdf"	
  end

end

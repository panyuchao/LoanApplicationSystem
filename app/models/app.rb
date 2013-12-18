# encoding: utf-8
require 'csv'
require "prawn"

class App < ActiveRecord::Base
	belongs_to :form
	  #attr_accessible :details,:amount,:pay_method,:account_num,:form_id
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |app|
        csv << app.attributes.values_at(*column_names)
      end
    end
  end
  
  def self.to_pdf
  	page = 1
  	count = 1
  	apps = App.order(:id)
  	left = 20
  	right = 530
  	xlen = right-left
  	height = 20
  	padding = 5
  	pdf = Prawn::Document.new
  	pdf.font_families.update("Sim Hei"=>{:normal =>"app/assets/fonts/simhei.ttf"})
		pdf.font "Sim Hei"
		pdf.stroke_line([left, 630], [right, 630])
		apps.each do |app|
			pdf.stroke_line([left, 630-count*height], [right, 630-count*height])
			pdf.text_box "#{app.id}", :at => [left, 630-count*height-padding], :width => 7*xlen/100, :align => :center
			pdf.text_box "#{app.details}", :at => [left+7*xlen/100, 630-count*height-padding], :width => 38*xlen/100, :align => :center
			pdf.text_box "#{app.created_at.strftime("%x")}", :at => [left+57*xlen/100, 630-count*height-padding], :width => 15*xlen/100, :align => :center
			pdf.text_box "#{app.amount}", :at => [left+72*xlen/100, 630-count*height-padding], :width => 12*xlen/100, :align => :center
			count += 1
			if count > 31 then
				count = 1
				start_new_page
			end
		end
		pdf.stroke_line([left, 630-count*height], [right, 630-count*height])
		pdf.stroke_line([left, 630], [left, 630-count*height])
		pdf.stroke_line([right, 630], [right, 630-count*height])
		left_now = left
		Form.get_pdf_th.each do |x|
			pdf.text_box "#{x[0]}", :at => [left_now, 625], :width => x[1]*xlen/100, :align => :center
			pdf.stroke_line([left_now, 630], [left_now, 630-count*height])
			left_now += x[1]*xlen/100
		end
		pdf.render_file "output.pdf"	
  end

end

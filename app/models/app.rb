# encoding: utf-8
require 'csv'

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

end

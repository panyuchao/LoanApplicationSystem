# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

apps = [{:details => 'Aladdin', :amount => 2000, :application_date => '25-Nov-1992'},
				  {:details => 'The Terminator', :amount => 20, :application_date => '26-Oct-1984'},
				  {:details => 'When Harry Met Sally', :amount => 13942, :application_date => '21-Jul-1989'},
			  	  {:details => 'The Help', :amount => 10293, :application_date => '10-Aug-2011'},
		  	 	 ]

apps.each do |a|
	App.create!(a)
end

class CreateForms < ActiveRecord::Migration
	def change
		create_table :forms do |t|
			t.string :applicant
			t.string :app_type
			t.timestamps
		end
		change_table :apps do |t|
			t.remove :applicant, :app_date, :app_type
		end
	end
end

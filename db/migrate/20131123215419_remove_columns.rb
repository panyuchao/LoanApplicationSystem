class RemoveColumns < ActiveRecord::Migration
	def change
		change_table :apps do |t|
			t.remove :checked_by, :handled_by
			t.integer :check_status # 0->not checked 1->need verify, accepted 2->need verify, rejected 3->accepted 4->rejected
		end
	end
end

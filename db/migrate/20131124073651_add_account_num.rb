class AddAccountNum < ActiveRecord::Migration
	def change
		change_table :apps do |t|
			t.string account_num
		end
	end

  def down
  end
end

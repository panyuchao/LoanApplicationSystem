class CreateTables < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :details
      t.float :amount
      t.string :pay_method	
      t.string :account_num	
      t.integer :form_id
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
    create_table :users do |t|
      t.string :user_name
			t.string :user_pass
			t.boolean :is_admin
      t.timestamps
    end
    create_table :forms do |t|
    	t.string :applicant
    	t.string :app_type
    	t.float :tot_amount
    	t.integer :check_status
    	t.integer :user_id
			t.timestamps
		end
  end

  def down
    drop_table :apps
    drop_table :users
    drop_table :forms
  end
end

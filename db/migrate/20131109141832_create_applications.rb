class CreateApplications < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :details
      t.string :amount
      t.string :pay_method	
      t.string :account_num	
      t.string :applicant	#deleted
      t.datetime :app_date	#deleted
      t.string :checked_by	#deleted
      t.string :handled_by	#deleted
      t.integer :app_type	#deleted
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
  end

  def down
    drop_table :apps
  end
end

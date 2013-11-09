class CreateApplications < ActiveRecord::Migration
  def up
    create_table :apps do |t|
      t.string :details
      t.string :amount
      t.integer :pay_method	
      t.string :account_num
      t.string :applicant
      t.datetime :application_date
      t.string :checked_by
      t.string :handled_by
      t.integer :type
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
  end

  def down
    drop_table :apps
  end
end

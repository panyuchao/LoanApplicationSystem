class AddUserProfile < ActiveRecord::Migration
  def up
  	add_column :users, :realname, :string
  end

  def down
  	remove_column :users, :realname
  end
end

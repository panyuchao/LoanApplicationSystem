class AddFormOtherinfo < ActiveRecord::Migration
  def up
    add_column :forms, :otherinfo, :string
  end

  def down
    remove_column :forms, :otherinfo
  end
end

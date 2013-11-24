class RemoveColumns < ActiveRecord::Migration
  def change
    change_table :apps do |t|
      t.remove :checked_by, :handled_by
      t.integer :check_status # 0->not checked 1->need verify 2->accepted 3->refused
    end
  end
end

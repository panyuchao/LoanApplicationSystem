class AddTicketToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ticket, :string
  end
end

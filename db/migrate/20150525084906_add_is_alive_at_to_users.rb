class AddIsAliveAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_alive_at, :datetime
  end
end

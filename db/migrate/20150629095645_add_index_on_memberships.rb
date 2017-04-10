class AddIndexOnMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, [ :room_id, :user_id ]
  end
end

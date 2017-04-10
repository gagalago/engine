class AddUniqueIndexOnMemberships < ActiveRecord::Migration
  def change
    remove_index :memberships, [ :room_id, :user_id ]
    add_index :memberships, [ :room_id, :user_id ], unique: true
  end
end

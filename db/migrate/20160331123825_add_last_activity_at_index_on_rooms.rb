class AddLastActivityAtIndexOnRooms < ActiveRecord::Migration
  def change
    add_index :rooms, :last_activity_at
  end
end

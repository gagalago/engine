class AddPlatformIdToRoom < ActiveRecord::Migration
  def up
    add_column :rooms, :platform_id, :uuid
    Room.all.each do |room|
      if room.platform_id.nil?
        room.platform_id = room.initiator.platform_id
        room.save!
      end
    end
    change_column :rooms, :platform_id, :uuid, null: false, index: true
  end

  def down
    remove_column :rooms, :platform_id
  end
end

class AddLastActivityAtToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :last_activity_at, :datetime
    Room.all.each do |room|
      room.last_activity_at = room.created_at
      last_message = room.messages.order(sequence_number: :desc).first
      if last_message
        room.last_activity_at = last_message.created_at
      end
      room.save!
    end
    change_column :rooms, :last_activity_at, :datetime, null: false
  end
end

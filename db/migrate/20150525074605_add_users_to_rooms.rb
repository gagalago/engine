class AddUsersToRooms < ActiveRecord::Migration
  def change
    create_table :memberships, id: :uuid do |t|
      t.uuid       :room_id, index: true
      t.uuid       :user_id, index: true
      t.boolean    :active, default: true
      t.timestamps null: false
    end

    add_column :rooms, :initiator_id, :uuid
    add_index  :rooms, :initiator_id
  end
end

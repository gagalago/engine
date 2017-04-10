class AddMessageUserStatus < ActiveRecord::Migration[5.0]
  def change
    create_table :message_user_statuses, id: :uuid do |t|
      t.uuid    :message_id, null: false,    index: true
      t.uuid    :user_id,    null: false,    index: true
      t.boolean :notified,   default: false, null: false
      t.boolean :read,       default: false, null: false
      t.timestamps
    end
    add_index :message_user_statuses, [:message_id, :user_id], unique: true, name: :idx_message_status_component_key
    add_foreign_key :message_user_statuses,  :users,     name: :fk_message_status_to_users
    add_foreign_key :message_user_statuses,  :messages,  name: :fk_message_status_to_messages

    mark_every_message_as_read

    remove_column :messages, :read_by_user_ids
  end


  def mark_every_message_as_read
    ActiveRecord::Base.connection.execute("
      INSERT INTO message_user_statuses(user_id, message_id, notified, read, created_at, updated_at)
      SELECT u.id AS user_id,
             m.id AS message_id,
             TRUE AS notified,
             TRUE AS read,
             m.created_at,
             m.updated_at
      FROM users u
      JOIN memberships ms ON ms.user_id=u.id
      JOIN rooms r ON ms.room_id=r.id
      JOIN messages m ON m.room_id=r.id
    ")
  end
end

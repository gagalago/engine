class AddMissingForeignKeys < ActiveRecord::Migration[5.0]
  def change
    add_foreign_key :messages,    :rooms,        column: :room_id,      name: :fk_message_to_rooms
    add_foreign_key :messages,    :users,        column: :sender_id,    name: :fk_message_to_senders
    add_foreign_key :rooms,       :platforms,    column: :platform_id,  name: :fk_room_to_platforms
    add_foreign_key :rooms,       :users,        column: :initiator_id, name: :fk_room_to_initiator_user
    add_foreign_key :memberships, :rooms,        column: :room_id,      name: :fk_membership_to_rooms
    add_foreign_key :memberships, :users,        column: :user_id,      name: :fk_membership_to_users
    add_foreign_key :users,       :platforms,    column: :platform_id,  name: :fk_user_to_platforms
  end
end

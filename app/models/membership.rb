# == Schema Information
#
# Table name: memberships
#
#  id         :uuid             not null, primary key
#  room_id    :uuid
#  user_id    :uuid
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  open       :boolean          default(FALSE)
#
# Indexes
#
#  index_memberships_on_room_id              (room_id)
#  index_memberships_on_room_id_and_user_id  (room_id,user_id) UNIQUE
#  index_memberships_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_membership_to_rooms  (room_id => rooms.id)
#  fk_membership_to_users  (user_id => users.id)
#

class Membership < ActiveRecord::Base
  track_entity_changes user_metadata: {
    create: lambda do
      {
        user_public_id: user.public_id,
        room_public_id: room.public_id
      }
    end
  }

  belongs_to :room
  belongs_to :user

  validates :room, presence: true
  validates :user, presence: true
end

class MembershipService

  def self.add_membership_from_client(platform, user, params)
    Membership.transaction do
      membership = MembershipFactory.build_from_client(platform, user, params)
      membership.save!
      MessageUserStatus.create_read_statuses_for(membership)
      membership
    end
  end

  def self.add_membership_from_server(platform, params)
    Membership.transaction do
      membership = MembershipFactory.build_from_server(platform, params)
      membership.save!
      MessageUserStatus.create_read_statuses_for(membership)
      membership
    end
  end

  def self.destroy_membership(platform, user_public_id, room_public_id)
    Membership.transaction do
      user       = platform.users.find_by!(public_id: user_public_id)
      room       = platform.rooms.find_by!(public_id: room_public_id)
      membership = platform.memberships.find_by!(user_id: user.id, room_id: room.id)
      membership.destroy!
      MessageUserStatus.destroy_statuses_for_user_in_room(user.id, room.id)
      membership
    end
  end
end

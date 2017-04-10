class MembershipFactory
  def self.build_from_client(platform, user, params)
    membership      = Membership.new
    membership.room = user.rooms.find_by!(public_id: params[:room_id])
    user_id         = params.dig(:data, :relationships, :user, :data, :id)
    membership.user = platform.users.find_by!(public_id: user_id)
    membership
  end

  def self.build_from_server(platform, params)
    room                  = platform.rooms.find_by!(public_id: params[:room_id])
    membership            = room.memberships.build
    membership.user       = platform.users.find_by!(public_id: params[:user_id])
    attributes            = params.dig(:data, :attributes) || {}
    membership.active     = attributes[:active]     unless attributes[:active].blank?
    membership.open       = attributes[:open]       unless attributes[:open].blank?
    membership.created_at = attributes[:created_at] unless attributes[:created_at].blank?
    membership.updated_at = attributes[:updated_at] unless attributes[:updated_at].blank?
    membership
  end
end

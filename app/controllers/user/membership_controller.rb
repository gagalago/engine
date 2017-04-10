class User::MembershipController < UserController
  def update
    open             = params.dig("data", "attributes", "open") == true
    room             = current_user.rooms.find_by!(public_id: params[:room_id])
    membership       = current_user.memberships.find_by(room_id: room.id)
    membership.open  = open
    membership.save!
    render json: User::MembershipPresenter.new(
      membership: membership,
      messages_per_room: 0,
      current_user: current_user
    )
  end
end

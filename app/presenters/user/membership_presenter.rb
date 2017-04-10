class User::MembershipPresenter < BasePresenter
  def initialize(membership:, messages_per_room:, current_user:)
    @membership        = membership
    @messages_per_room = messages_per_room
    @current_user      = current_user
  end

  def data
    {
      type:       "membership",
      id:         @membership.id,
      attributes: {
        open: @membership.open
      },
      relationships: {
        user: User::UserPresenter.new(@membership.user),
        room: User::RoomPresenter.new(
          room:               @membership.room,
          messages_per_room:  @messages_per_room,
          current_user:       @current_user,
          first_seen_message: nil
        )
      }
    }
  end
end

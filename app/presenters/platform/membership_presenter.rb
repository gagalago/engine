class Platform::MembershipPresenter < BasePresenter
  def data
    {
      type:       "membership",
      id:         @object.id,
      attributes: {
        open: @object.open
      },
      relationships: {
        user: Platform::UserPresenter.new(@object.user),
        room: Platform::RoomPresenter.new(@object.room)
      }
    }
  end
end

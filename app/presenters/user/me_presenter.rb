class User::MePresenter < BasePresenter
  def data
    {
      type:       "user",
      id:         @object.public_id,
      meta: {
        unreadMessageCount: @object.unread_message_count,
        roomCount:          @object.rooms.size
      }
    }
  end
end

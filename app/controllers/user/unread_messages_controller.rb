class User::UnreadMessagesController < UserController
  def update
    room         = current_user.rooms.find_by!(public_id: params[:room_id])
    new_statuses = MessageUserStatus.mark_all_as_read_in_room_for_user(current_user.id, room.id, params.dig(:data, :last_read_message_id))
    render json: User::UnreadMessagesPresenter.new(new_statuses)
  end
end

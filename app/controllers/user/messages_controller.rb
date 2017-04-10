class User::MessagesController < UserController
  def index
    first_seen_message = nil
    messages_per_page  = params[:per_page].try(:to_i) || Message::PER_PAGE
    room               = current_user.rooms.find_by!(public_id: params[:room_id])

    if params[:first_seen_message_id]
      first_seen_message = room.messages.find_by!(public_id: params[:first_seen_message_id])
    end

    message_count = room.messages.count
    messages      = room.messages_before(messages_per_page, first_seen_message)
    render json: User::MessagePresenter.map(
      messages: messages,
      room_public_id: room.public_id,
      message_count: message_count
    )
  end

  def create
    Message.transaction do
      message = MessageFactory.build_from_client(current_user, params)
      room    = message.room
      room.update_last_activity!
      message.save!
      render json: User::MessagePresenter.new(
        message: message,
        room_public_id: room.public_id
      ), status: :created
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { errors: [
      {
        status: 403,
        title:  "Message id already exists",
        code:   "already_exists",
        source: { parameter: "messageId" }
      }
    ] }, status: :forbidden
  end

  def destroy
    message = current_user.messages.find_by!(public_id: params[:id], sender_id: current_user.id)
    message.destroy!
    render json: User::DestroyedMessagePresenter.new(message)
  end
end

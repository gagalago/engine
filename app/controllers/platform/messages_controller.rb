class Platform::MessagesController < PlatformController
  def index
    first_seen_message = nil
    messages_per_page  = params[:per_page].try(:to_i) || Message::PER_PAGE
    room               = current_platform.rooms.find_by!(public_id: params[:room_id])

    if params[:first_seen_message_id]
      first_seen_message = room.messages.find_by!(public_id: params[:first_seen_message_id])
    end

    message_count = room.messages.count
    messages      = room.messages_before(messages_per_page, first_seen_message)
    render json: Platform::MessagePresenter.map(
      messages:       messages,
      room_public_id: room.public_id,
      message_count:  message_count
    )
  end

  def create
    Message.transaction do
      message = MessageFactory.build_from_server(current_platform, params)
      message.room.update_last_activity!
      message.save!
      render json: Platform::MessagePresenter.new(
        message: message,
        room_public_id: message.room.public_id
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
    Message.transaction do
      room    = current_platform.rooms.find_by!(public_id: params[:room_id])
      message = room.messages.find_by!(public_id: params[:id])
      message.destroy!
      render json: Platform::MessagePresenter.new(
        message: message,
        room_public_id: room.public_id
      )
    end
  end
end

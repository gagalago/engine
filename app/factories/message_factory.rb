class MessageFactory
  def self.build_from_client(sender, params)
    room                      = sender.rooms.find_by!(public_id: params[:room_id])
    message                   = room.messages.build
    id                        = params.dig(:data, :id)
    message.public_id         = id.blank? ? SecureRandom.uuid : id
    attributes                = params.dig(:data, :attributes) || {}
    message.content           = attributes[:content] unless attributes[:content].blank?
    message.content_type      = attributes[:content_type] || "text"
    message.sender            = sender
    message.device_session_id = attributes[:device_session_id]
    build_statuses_for_new(message)
    message
  end

  def self.build_from_server(platform, params)
    room                     = platform.rooms.find_by!(public_id: params[:room_id])
    message                  = room.messages.build
    id                       = params.dig(:data, :id)
    message.public_id        = id.blank? ? SecureRandom.uuid : id
    attributes               = params.dig(:data, :attributes) || {}
    message.content          = attributes[:content]    unless attributes[:content].blank?
    message.created_at       = attributes[:created_at] unless attributes[:created_at].blank?
    message.updated_at       = attributes[:updated_at] unless attributes[:updated_at].blank?
    message.content_type     = attributes[:content_type] || "text"
    relationships            = params.dig(:data, :relationships) || {}
    user_id                  = relationships.dig(:user, :data, :id)
    message.sender           = platform.users.find_by!(public_id: user_id) if user_id
    build_statuses_for_new(message, attributes[:read_by_user_ids] || [])
    message
  end

  private

  def self.build_statuses_for_new(message, already_read_by_user_public_ids=[])
    message.room.users.each do |user|
      is_read = user == message.sender || already_read_by_user_public_ids.include?(user.public_id)
      MessageUserStatus.build_from_message(message, user, is_read)
    end
  end
end

class Platform::MessagePresenter < BasePresenter
  def self.map(messages:, room_public_id:, message_count: 0)
    array = messages.map do |message|
      new(message: message, room_public_id: room_public_id).data
    end

    {
      data: array,
      meta: {
        count: message_count
      }
    }
  end

  def initialize(message:, room_public_id:)
    @message        = message
    @room_public_id = room_public_id
  end

  def data
    result = {
      type:       "message",
      id:         @message.public_id,
      attributes: {
        roomId:       @room_public_id,
        content:      @message.content,
        contentType:  @message.content_type,
        createdAt:    @message.created_at
      }
    }
    result[:attributes][:senderId] = @message.sender.public_id if @message.sender
    result
  end
end

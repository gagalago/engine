class UnreadMessagesHookWorker
  include Sidekiq::Worker

  def perform(message_id, platform_id)
    message = Message.includes(:room)
                     .includes(:sender)
                     .includes(message_user_statuses: [:user])
                     .find_by(id: message_id)
    platform = Platform.find(platform_id)
    if message.present? && platform.has_offline_message_hook?
      message.recipients.each do | recipient |
        body = create_body(message, recipient)
        hook(body, platform)
      end
    end
  end

  private

  def create_body(message, recipient)
    data = {
      id: message.public_id,
      attributes: {
        content: message.content,
        contentType: message.content_type,
        createdAt: message.created_at
      },
      relationships: {
        room: {
          data: {
            type: :room,
            id: message.room.public_id
          }
        },
        recipient: {
          data: {
            type: :user,
            id: recipient.public_id
          }
        }
      }
    }

    if message.sender&.public_id.present?
      data[:relationships][:sender] = {
        type: :user,
        id: message.sender.public_id
      }
    end

    {
      data: data
    }
  end

  def hook(body, platform)
    RestClient.post(platform.offline_user_message_hook_url, body, {})
  end
end

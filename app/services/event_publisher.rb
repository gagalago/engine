class EventPublisher

  def self.notify_offline_messages(recipient, messages, room)
    unless messages.empty?
      data = {
        relationships: {
          recipient: {
            data: {
              type: :user,
              id:   recipient.public_id
            }
          },
          messages: {
            data: messages.map {|message| create_body_for_message(message)}
          },
          room: {
            data: {
              type: :room,
              id:   room.public_id,
              name: room.name
            }
          }
        }
      }
      publish("notify offline messages", {data: data})
    end
  end

  private

  def self.publish(name, data)
    event = Flu.event_factory.build_event(name, :manual, data)
    Flu.event_publisher.publish(event)
  end

  def self.create_body_for_message(message)
    body = {
      type:          :message,
      id:            message.public_id,
      content:       message.content,
      createdAt:     message.created_at,
      platformId:    message.platform_id,
      relationships: {}
    }
    unless message.sender.nil?
      body[:relationships][:sender] = {
        type: :user,
        id:   message.sender.public_id
      }
    end
    body
  end
end

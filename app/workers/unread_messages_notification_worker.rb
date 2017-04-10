class UnreadMessagesNotificationWorker
  include Sidekiq::Worker

  def perform(platform_id, recipient_id, room_id, message_ids)
    Rails.logger.info("Marking #{message_ids.size} messages as notified for platform_id=#{platform_id} and room_id=#{room_id} and recipient_id=#{recipient_id}: #{message_ids}")
    Message.transaction do
      messages = Message.unnotified_for_user(recipient_id)
                        .includes(:room)
                        .includes(:sender)
                        .where(id: message_ids)
      unless messages.empty?
        mark_recipient_as_notified(messages, recipient_id)
        call_platform_offline_hook(messages, platform_id)
        emit_event(messages, recipient_id)
      end
    end
  end

  private

  def mark_recipient_as_notified(messages, recipient_id)
    messages.each do | message |
      message.notified_to(recipient_id)
      message.save!
    end
  end

  def call_platform_offline_hook(messages, platform_id)
    platform = Platform.find(platform_id)
    if platform.has_offline_message_hook?
      messages.each do |message|
        UnreadMessagesHookWorker.perform_async(message.id, platform_id)
      end
    end
  end

  def emit_event(messages, recipient_id)
    room      = messages.first.room
    recipient = User.find(recipient_id)
    EventPublisher.notify_offline_messages(recipient, messages, room)
  end
end

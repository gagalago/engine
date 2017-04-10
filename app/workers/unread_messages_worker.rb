class UnreadMessagesWorker
  include Sidekiq::Worker
  sidekiq_options unique: :until_executed

  def perform
    Message.all_unnotified_messages_ids_per_user_per_room.each do | unnotified |
      UnreadMessagesNotificationWorker.perform_async(unnotified.platform_id,
                                                     unnotified.user_id,
                                                     unnotified.room_id,
                                                     unnotified.message_ids)
    end
  end
end

class Internal::SendUnreadMessagesController < InternalController
  def create
    UnreadMessagesWorker.perform_async
    render head: true, status: :accepted
  end
end

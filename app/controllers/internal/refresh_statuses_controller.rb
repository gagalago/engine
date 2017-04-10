class Internal::RefreshStatusesController < InternalController
  def create
    StatusWorker.perform_async
    render head: true, status: :accepted
  end
end

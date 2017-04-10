class User::UnreadMessagesPresenter < BasePresenter
  def initialize(statuses)
    @statuses = statuses
  end

  def data
    {
      type: "unreadMessages"
    }
  end

  def meta
    {
      count: @statuses.size
    }
  end
end

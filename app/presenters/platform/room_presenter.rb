class Platform::RoomPresenter < BasePresenter
  def self.map(rooms:, room_count:)
    array = rooms.map do |room|
      new(room).data
    end

    {
      data: array,
      meta: {
        count: room_count
      }
    }
  end

  def data
    result = {
      type:       "room",
      id:         @object.public_id,
      attributes: {
        name:           @object.name,
        lastActivityAt: @object.last_activity_at,
        createdAt:      @object.created_at
      },
      relationships: {
        users:    Platform::UserPresenter.map(@object.users)
      }
    }
    result[:relationships][:initiator] =  Platform::UserPresenter.new(@object.initiator).data if @object.initiator
    result
  end
end

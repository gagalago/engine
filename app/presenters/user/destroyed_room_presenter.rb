class User::DestroyedRoomPresenter < BasePresenter
  def data
    {
      type: "room",
      id:   @object.public_id
    }
  end
end

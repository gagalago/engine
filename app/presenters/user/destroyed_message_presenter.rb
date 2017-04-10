class User::DestroyedMessagePresenter < BasePresenter
  def data
    {
      type: "message",
      id:   @object.public_id
    }
  end
end

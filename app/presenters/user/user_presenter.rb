class User::UserPresenter < BasePresenter
  def data
    {
      type:       "user",
      id:         @object.public_id,
      attributes: {
        status: @object.status
      }
    }
  end
end

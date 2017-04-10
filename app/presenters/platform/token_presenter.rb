class Platform::TokenPresenter < BasePresenter
  def data
    {
      type:       "token",
      attributes: {
        token: @object
      }
    }
  end
end
